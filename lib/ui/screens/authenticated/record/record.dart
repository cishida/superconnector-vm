import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_upchunk/flutter_upchunk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/core/utils/video/better_player_utility.dart';
import 'package:superconnector_vm/core/utils/video/camera_utility.dart';
import 'package:superconnector_vm/core/utils/video/video_uploader.dart';
import 'package:superconnector_vm/main.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/camera_preview_container.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/record_bottom_nav.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/record_overlay.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/video_preview.dart';

class Record extends StatefulWidget {
  const Record({
    Key? key,
    required this.connection,
  }) : super(key: key);

  final Connection? connection;

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  CameraController? _cameraController;
  DocumentReference _videoDoc =
      FirebaseFirestore.instance.collection('videos').doc();
  XFile? _videoFile;
  BetterPlayerController? _betterPlayerController;
  // VoidCallback? _videoPlayerListener;
  int _progress = 0;
  UpChunk? _upchunk;
  bool _uploadCompleted = false;
  bool _sendPressed = false;
  bool _isRecording = false;
  bool _isResetting = false;
  bool _shouldShowVideo = false;
  double? _aspectRatio;

  void _safeSetState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future initCamera({CameraDescription? description}) async {
    var status = await Permission.camera.status;

    if (description == null) {
      description = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (status.isGranted && cameras.isNotEmpty) {
      _cameraController = await CameraUtility.initializeController(
        description,
      );
      _safeSetState();
    }
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    if (_cameraController == null) {
      return;
    }

    final lensDirection = _cameraController!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      initCamera(description: newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  Future<void> _setVideoFile(XFile file) async {
    if (mounted) {
      setState(() {
        _videoFile = file;
      });
    }
    await initializeVideo();
    await _uploadFile();
  }

  Future initializeVideo() async {
    if (_videoFile == null) {
      return;
    }

    _betterPlayerController = await BetterPlayerUtility.initializeFromVideoFile(
      size: MediaQuery.of(context).size,
      videoFile: _videoFile!,
      onEvent: () {
        if (_betterPlayerController != null) {
          _safeSetState();
        }
      },
    );
    _betterPlayerController!.addEventsListener((event) {
      if (_betterPlayerController != null) {
        bool? isInitialized = _betterPlayerController!.isVideoInitialized();
        // bool? isPlaying = _betterPlayerController!.isPlaying();
        _shouldShowVideo = isInitialized != null && isInitialized; //&&
        // isPlaying != null &&
        // isPlaying;
        _aspectRatio = _betterPlayerController!.getAspectRatio();
      }
    });

    _safeSetState();
  }

  Future onNewCameraSelected(
    CameraDescription cameraDescription,
  ) async {
    if (_cameraController != null) {
      CameraController temp = _cameraController!;
      if (mounted) {
        setState(() {
          _cameraController = null;
        });
      }
      await temp.dispose();
    }
    await initCamera();
    _safeSetState();
  }

  Future _onResetPressed() async {
    if (mounted) {
      setState(() {
        _isResetting = true;
      });
    }

    if (_cameraController != null) {
      await onNewCameraSelected(_cameraController!.description);
    } else {
      await initCamera();
    }

    if (_upchunk != null) {
      try {
        _upchunk!.stop();
      } catch (e) {
        print(e);
      }
    }

    _animationController.reset();

    if (mounted) {
      setState(() {
        _shouldShowVideo = false;
        _isRecording = false;
        _betterPlayerController = null;
        _videoFile = null;
        _uploadCompleted = false;
        _sendPressed = false;
        _videoDoc = FirebaseFirestore.instance.collection('videos').doc();
        _progress = 0;
        _isResetting = false;
      });
    }
  }

  Future<void> _uploadFile() async {
    _progress = 0;
    final superuser = Provider.of<Superuser?>(context, listen: false);
    final uploader = VideoUploader();
    Video video = Video(id: _videoDoc.id, created: DateTime.now());

    final json = await uploader.getUploadJson(video.id);
    video.uploadId = json['id'];

    if (superuser == null || _videoFile == null) {
      print('Superuser or video file is null');
      return;
    }

    // Chunk upload
    var uploadOptions = UpChunkOptions()
      ..chunkSize = 5120 * 10
      ..endPoint = json['url']
      ..file = File(_videoFile!.path)
      ..onProgress = (double progress) {
        if (_upchunk != null && _videoFile == null) {
          _upchunk!.stop();
        }
        if (mounted) {
          setState(() {
            _progress = progress.floor();
          });
        }
      }
      ..onError = (
        String message,
        int chunk,
        int attempts,
      ) {
        print(message);
      }
      ..onSuccess = () async {
        if (_betterPlayerController == null) {
          return;
        }

        await _videoDoc.set({
          'uploadId': video.uploadId,
          'superuserId': superuser.id,
          'caption': video.caption,
          'created': Timestamp.now(),
          'duration': BetterPlayerUtility.getVideoDuration(
            _betterPlayerController,
          ),
          'views': 0,
          'deleted': false,
        });

        if (mounted) {
          setState(() {
            _uploadCompleted = true;
          });
        }

        if (_sendPressed) {
          await _sendVM();
        }
      };

    _upchunk = UpChunk.createUpload(uploadOptions);
  }

  Future<void> _onSendPressed() async {
    if (_videoFile == null) {
      return;
    }

    setState(() {
      _sendPressed = true;
    });

    if (_uploadCompleted) {
      await _sendVM();
    }
  }

  Future _sendVM() async {
    setState(() {
      _sendPressed = true;
    });
    final superuser = Provider.of<Superuser?>(context, listen: false);
    if (superuser == null) {
      return;
    }

    final analytics = Provider.of<FirebaseAnalytics>(
      context,
      listen: false,
    );

    //     // Connection connection = await ConnectionService().getOrCreateConnection(
    //     //   currentUserId: superuser.id,
    //     //   selectedContacts: selectedContacts,
    //     //   connections: connections,
    //     //   analytics: analytics,
    //     // );

    // await _videoDoc.update({
    //   'connectionId': widget.connection.id,
    //   'unwatchedIds': widget.connection.userIds
    //       .where((element) => element != superuser.id)
    //       .toList(),
    // });

    // widget.connection.mostRecentActivity = DateTime.now();
    // await widget.connection.update();

    // analytics.logEvent(
    //   name: 'vm_sent',
    //   parameters: <String, dynamic>{
    //     'id': _videoDoc.id,
    //     'senderId': superuser.id,
    //     'connectionId': widget.connection.id,
    //     'duration': BetterPlayerUtility.getVideoDuration(
    //       _betterPlayerController,
    //     ),
    //   },
    // );

    // Navigator.of(context).popUntil((route) => route.isFirst);
    return;
  }

  // Future _showInviteCard(
  //   List<String> phoneNumbers,
  // ) async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) {
  //       return Stack(
  //         children: [
  //           SuperDialog(
  //             title: 'Invitation',
  //             subtitle:
  //                 'They need a Superconnector invitation to connect with you and share VMs.',
  //             primaryActionTitle: 'Continue',
  //             primaryAction: () async {
  //               String body =
  //                   'Hey I just sent you a VM in Superconnector, get the app so we can VM each other faster https://www.superconnector.com/';

  //               await SMSUtility.send(body, phoneNumbers);
  //               Navigator.pop(context);
  //             },
  //             secondaryActionTitle: 'Cancel',
  //             secondaryAction: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addObserver(this);

    super.initState();
    initCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: ConstantValues.VIDEO_TIME_LIMIT * 1000,
      ),
    );
    _animationController.addListener(() {
      _safeSetState();
    });
  }

  void dispose() {
    WidgetsFlutterBinding.ensureInitialized().removeObserver(this);
    _animationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
      setState(() {
        _isResetting = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      if (_cameraController != null) {
        onNewCameraSelected(_cameraController!.description);
        setState(() {
          _isResetting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              alignment: Alignment.center,
              children: [
                // Camera preview for recording VM
                // if (_cameraController != null &&
                //     _cameraController!.value.isInitialized &&
                //     !_shouldShowVideo)
                AnimatedOpacity(
                  opacity: !_shouldShowVideo ? 1.0 : 0.0,
                  duration: const Duration(
                    milliseconds:
                        ConstantValues.CAMERA_TO_VIDEO_PLAYER_MILLISECONDS,
                  ),
                  child: CameraPreviewContainer(
                    cameraController: _cameraController,
                    animationController: _animationController,
                    ratio: 9 / 16,
                    constraints: constraints,
                    setVideoFile: _setVideoFile,
                    setIsRecording: (isRecording) {
                      setState(() {
                        _isRecording = isRecording;
                      });
                    },
                    isResetting: _isResetting,
                  ),
                ),

                // Video player after VM recorded
                // if (_shouldShowVideo)
                AnimatedOpacity(
                  opacity: _shouldShowVideo ? 1.0 : 0.0,
                  duration: const Duration(
                    milliseconds:
                        ConstantValues.CAMERA_TO_VIDEO_PLAYER_MILLISECONDS,
                  ),
                  child: VideoPreview(
                    aspectRatio: _aspectRatio,
                    betterPlayerController: _betterPlayerController,
                    constraints: constraints,
                  ),
                ),

                RecordOverlay(
                  isRecording: _isRecording,
                  connection: widget.connection,
                  toggleCamera: () => _toggleCameraLens(),
                ),

                if (_sendPressed && !_uploadCompleted)
                  Container(
                    color: Colors.black.withOpacity(0.65),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text(
                            _progress.toString() + '%',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: RecordBottomNav(
              shouldShowSendVM: _betterPlayerController != null,
              onResetPressed: _onResetPressed,
              onSendPressed: _onSendPressed,
            ),
          );
        },
      ),
    );
  }
}
