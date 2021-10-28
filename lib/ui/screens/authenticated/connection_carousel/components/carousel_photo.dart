import 'dart:io';
import 'dart:ui';

import 'package:better_player/better_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/models/photo/photo.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/utils/video/video_player_helper.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_transform.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/components/custom_controls_widget.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/components/video_meta_data.dart';

class CarouselPhoto extends StatefulWidget {
  const CarouselPhoto({
    Key? key,
    required this.photo,
  }) : super(key: key);

  final Photo photo;

  @override
  _CarouselPhotoState createState() => _CarouselPhotoState();
}

class _CarouselPhotoState extends State<CarouselPhoto> {
  Superuser? _photoSuperuser;
  BetterPlayerTheme _playerTheme = BetterPlayerTheme.custom;
  bool _showedCard = false;

  Future _loadUserAndLog() async {
    _logWatchedEvent();
    if (mounted) {
      setState(() {});
    }
  }

  void _logWatchedEvent() {
    Superuser? currentSuperuser = Provider.of<Superuser?>(
      context,
      listen: false,
    );
    if (_photoSuperuser == null || currentSuperuser == null) {
      return;
    }

    if (widget.photo.unwatchedIds.contains(currentSuperuser.id)) {
      widget.photo.unwatchedIds.remove(currentSuperuser.id);
      widget.photo.update();
      currentSuperuser.decrementUnseenNotificationCount();
    }

    final analytics = Provider.of<FirebaseAnalytics>(
      context,
      listen: false,
    );

    analytics.logEvent(
      name: 'photo_watched',
      parameters: <String, dynamic>{
        'photo_id': widget.photo.id,
        'watcher_id': currentSuperuser.id,
      },
    );
  }

  Future _showCard() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SuperDialog(
          title: 'Overview',
          subtitle:
              'Swipe up and down to navigate through photos and videos on a camera roll.',
          primaryActionTitle: 'Continue',
          primaryAction: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserAndLog();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var aspectRatio = _betterPlayerController.getAspectRatio();
    Size size = MediaQuery.of(context).size;

    Superuser? superuser = Provider.of<Superuser?>(context);

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      if (superuser != null &&
          !superuser.videoPlayerOnboarding &&
          !_showedCard) {
        if (mounted) {
          setState(() {
            _showedCard = true;
          });
        }
        await _showCard();
        superuser.videoPlayerOnboarding = true;
        await superuser.update();
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        children: [
          Positioned.fill(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cameraHandler = Provider.of<CameraHandler>(
                  context,
                  listen: false,
                );

                if (cameraHandler.imageFile != null) {
                  return CameraTransform(
                    constraints: constraints,
                    isImage: true,
                    child: Image.file(
                      File(
                        cameraHandler.imageFile!.path,
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          if (_photoSuperuser != null)
            VideoMetaData(
              created: widget.photo.created,
              superuser: _photoSuperuser!,
              caption: widget.photo.caption,
            ),
        ],
      ),
    );
  }
}
