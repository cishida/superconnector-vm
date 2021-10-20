import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:camera/camera.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/core/utils/nav/authenticated_controller.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/core/utils/sms_utility.dart';
import 'package:superconnector_vm/core/utils/video/better_player_utility.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/components/video_meta_data.dart';
import 'dart:ui' as ui;

import 'package:superconnector_vm/ui/screens/authenticated/record/components/video_preview.dart';

class VideoPreviewContainer extends StatefulWidget {
  const VideoPreviewContainer({
    Key? key,
    required this.videoFile,
    required this.onReset,
    this.blurredThumb,
    this.connection,
  }) : super(key: key);

  final XFile videoFile;
  final Function onReset;
  final Uint8List? blurredThumb;
  final Connection? connection;

  @override
  _VideoPreviewContainerState createState() => _VideoPreviewContainerState();
}

class _VideoPreviewContainerState extends State<VideoPreviewContainer> {
  BetterPlayerController? _betterController;
  // ConnectionService _connectionService = ConnectionService();
  // double? _aspectRatio;
  bool _pressed = false;
  Duration? _duration = Duration(seconds: 0);
  Duration? _position = Duration(seconds: 0);
  bool _hasPlayed = false;

  void _safeSetState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future _showInviteCard(
    List<String> phoneNumbers,
  ) async {
    if (phoneNumbers.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            SuperDialog(
              title: 'Confirmation',
              subtitle:
                  'Send them a Superconnector invitation so you can both use your shared camera roll.',
              primaryActionTitle: 'Continue',
              primaryAction: () async {
                String body = ConstantStrings.TARGETED_INVITE_COPY +
                    ConstantStrings.TESTFLIGHT_LINK;

                await SMSUtility.send(body, phoneNumbers);
                Navigator.pop(context);
              },
              secondaryActionTitle: 'Cancel',
              secondaryAction: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
      // if (_betterController != null) {
      //   _aspectRatio = _betterController!.getAspectRatio();
      // }
      if (!_hasPlayed &&
          event.betterPlayerEventType == BetterPlayerEventType.progress) {
        _hasPlayed = true;
      }
    });

    _betterController!.videoPlayerController?.addListener(() {
      if (mounted) {
        setState(() {
          _position = _betterController!.videoPlayerController?.value.position;
          _duration = _betterController!.videoPlayerController?.value.duration;
        });
      }
    });

    _safeSetState();
  }

  Future prepareSelected() async {}

  Future sendVM() async {
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
    final cameraHandler = Provider.of<CameraHandler>(
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

    List<String> phoneNumbers = [];

    if (widget.connection == null) {
      selectedContacts.superusers.forEach((superuser) async {
        selectedContacts.addConnection(connections
            .where((element) =>
                element.userIds.length == 2 &&
                element.userIds.contains(superuser.id))
            .toList()
            .first);
      });

      await Future.forEach(selectedContacts.contacts, (Contact contact) async {
        Connection connection =
            await ConnectionService().createConnectionFromContact(
          currentUserId: currentSuperuser.id,
          contact: contact,
          analytics: analytics,
        );

        if (connection.phoneNumberNameMap.isNotEmpty) {
          phoneNumbers = connection.phoneNumberNameMap.keys.toList();
        }
        selectedContacts.addConnection(connection);
      });
    }

    await cameraHandler.createVideos(
      selectedContacts.connections,
      currentSuperuser,
      widget.videoFile,
      _betterController!,
    );

    await cameraHandler.disposeCamera();

    await _showInviteCard(phoneNumbers);
    selectedContacts.reset();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initializeVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    if (superuser == null) {
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // if (widget.blurredThumb != null)
              //   Positioned.fill(
              //     child: Container(
              //       width: constraints.maxWidth,
              //       height: constraints.maxHeight,
              //       child: Stack(
              //         children: [
              //           Image.memory(
              //             widget.blurredThumb!,
              //             width: constraints.maxWidth,
              //             height: constraints.maxHeight,
              //             fit: BoxFit.cover,
              //           ),
              //           BackdropFilter(
              //             filter: ui.ImageFilter.blur(
              //               sigmaX: 8.0,
              //               sigmaY: 8.0,
              //             ),
              //             child: Container(
              //               color: Colors.transparent,
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              if (_betterController != null &&
                  _betterController!.isVideoInitialized() != null &&
                  _betterController!.isVideoInitialized()!)
                Positioned.fill(
                  child: VideoPreview(
                    constraints: constraints,
                    aspectRatio: 9 / 16,
                    betterPlayerController: _betterController!,
                  ),
                ),
              if (widget.blurredThumb != null && !_hasPlayed)
                Positioned.fill(
                  child: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Stack(
                      children: [
                        Transform.scale(
                          scale: 9 /
                              16 /
                              (constraints.maxWidth / constraints.maxHeight),
                          child: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: Image.memory(
                              widget.blurredThumb!,
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        BackdropFilter(
                          filter: ui.ImageFilter.blur(
                            sigmaX: 8.0,
                            sigmaY: 8.0,
                          ),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )
                      ],
                    ),
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
                ),
              ),
              VideoMetaData(
                created: DateTime.now(),
                superuser: superuser,
                duration: _duration,
                position: _position,
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: ConstantColors.DARK_BLUE,
            child: Container(
              alignment: Alignment.centerRight,
              height: ConstantValues.BOTTOM_NAV_HEIGHT,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  if (_pressed) {
                    return;
                  }

                  setState(() {
                    _pressed = true;
                  });

                  var selectedContacts = Provider.of<SelectedContacts>(
                    context,
                    listen: false,
                  );

                  if (_betterController != null &&
                      _betterController!.isPlaying() != null &&
                      _betterController!.isPlaying()!) {
                    await _betterController!.pause();
                  }

                  if (widget.connection == null) {
                    SuperNavigator.handleContactsNavigation(
                      context: context,
                      sendVM: sendVM,
                    );
                  } else {
                    selectedContacts.addConnection(widget.connection!);
                    sendVM();

                    Navigator.of(context).popUntil((route) => route.isFirst);

                    Provider.of<AuthenticatedController>(
                      context,
                      listen: false,
                    ).setIndex(1);
                  }

                  setState(() {
                    _pressed = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Image.asset(
                    'assets/images/authenticated/record/send-vm-button.png',
                    width: 46.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
