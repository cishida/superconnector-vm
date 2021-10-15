import 'package:better_player/better_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/core/utils/video/better_player_utility.dart';
import 'package:superconnector_vm/core/utils/video/video_uploader.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/record_bottom_nav.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/video_preview.dart';

class VideoPreviewContainer extends StatefulWidget {
  const VideoPreviewContainer({
    Key? key,
    required this.videoFile,
    required this.onReset,
    this.connection,
  }) : super(key: key);

  final XFile videoFile;
  final Function onReset;
  final Connection? connection;

  @override
  _VideoPreviewContainerState createState() => _VideoPreviewContainerState();
}

class _VideoPreviewContainerState extends State<VideoPreviewContainer> {
  BetterPlayerController? _betterController;
  ConnectionService _connectionService = ConnectionService();
  double? _aspectRatio;

  void _safeSetState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future _initializeVideo() async {
    _betterController = await BetterPlayerUtility.initializeFromVideoFile(
      size: MediaQuery.of(context).size,
      videoFile: widget.videoFile,
      onEvent: () {
        if (_betterController != null) {
          _safeSetState();
        }
      },
    );
    _betterController!.addEventsListener((event) {
      if (_betterController != null) {
        _aspectRatio = _betterController!.getAspectRatio();
      }
    });

    _safeSetState();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      _initializeVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: VideoPreview(
                  constraints: constraints,
                  aspectRatio: 9 / 16,
                  betterPlayerController: _betterController,
                ),
              ),
              Positioned(
                top: 71.0 - 28.0,
                left: 0.0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    if (_betterController != null) {
                      await _betterController!.pause();
                    }

                    Navigator.of(context).pop();
                    widget.onReset();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Image.asset(
                      'assets/images/authenticated/record/reset-button.png',
                      width: 18.0,
                    ),
                  ),
                  // Text(
                  //   'Reset',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 20.0,
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: ConstantColors.DARK_BLUE,
            child: Container(
              alignment: Alignment.centerRight,
              height: 55.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  print('send');
                  if (_betterController != null &&
                      _betterController!.isPlaying() != null &&
                      _betterController!.isPlaying()!) {
                    await _betterController!.pause();
                  }
                  if (widget.connection == null) {
                    SuperNavigator.handleContactsNavigation(
                      context: context,
                      sendVM: () async {
                        var selectedContacts = Provider.of<SelectedContacts>(
                          context,
                          listen: false,
                        );
                        final analytics = Provider.of<FirebaseAnalytics>(
                          context,
                          listen: false,
                        );
                        final connections = Provider.of<List<Connection>>(
                          context,
                          listen: false,
                        );
                        final currentSuperuser = Provider.of<Superuser?>(
                          context,
                          listen: false,
                        );

                        if (currentSuperuser == null) {
                          return;
                        }

                        final uploader = VideoUploader();
                        DocumentReference _videoDoc = FirebaseFirestore.instance
                            .collection('videos')
                            .doc();
                        Video initialVideo =
                            Video(id: _videoDoc.id, created: DateTime.now());
                        final json =
                            await uploader.getUploadJson(initialVideo.id);
                        initialVideo.uploadId = json['id'];

                        selectedContacts.contacts.forEach((contact) {});
                        selectedContacts.getSuperusers.forEach(
                          (superuser) async {
                            Connection? connection = connections
                                .where((element) =>
                                    element.userIds.length == 2 &&
                                    element.userIds.contains(superuser.id))
                                .toList()
                                .first;

                            if (connection != null) {
                              DocumentReference _videoDoc = FirebaseFirestore
                                  .instance
                                  .collection('videos')
                                  .doc();
                              await _videoDoc.set({
                                'uploadId': initialVideo.uploadId,
                                'superuserId': superuser.id,
                                'created': Timestamp.now(),
                                'duration':
                                    BetterPlayerUtility.getVideoDuration(
                                  _betterController,
                                ),
                                'views': 0,
                                'deleted': false,
                                'connectionId': connection.id,
                                'unwatchedIds': [superuser.id],
                              });

                              connection.mostRecentActivity = DateTime.now();
                              await connection.update();
                            }
                          },
                        );

                        selectedContacts.reset();
                      },
                    );
                  }
                },
                child: Image.asset(
                  'assets/images/authenticated/record/send-vm-button.png',
                  width: 46.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
