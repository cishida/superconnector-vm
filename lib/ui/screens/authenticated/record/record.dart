import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_upchunk/flutter_upchunk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/core/utils/video/video_player_helper.dart';
import 'package:superconnector_vm/core/utils/video/video_uploader.dart';
import 'package:superconnector_vm/main.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/camera_preview_container.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/record_bottom_nav.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/record_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:video_player/video_player.dart';

class Record extends StatefulWidget {
  const Record({
    Key? key,
  }) : super(key: key);

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
  VideoPlayerHelper _videoPlayerHelper = VideoPlayerHelper();
  // VoidCallback? _videoPlayerListener;
  int _progress = 0;
  UpChunk? _upchunk;
  bool _uploadCompleted = false;
  bool _sendPressed = false;
  bool _isRecording = false;
  bool _isResetting = false;

  Future initCamera() async {
    var status = await Permission.camera.status;

    if (status.isGranted && cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras.firstWhere((description) =>
            description.lensDirection == CameraLensDirection.front),
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _cameraController!.initialize();
      await _cameraController!.prepareForVideoRecording();
      if (mounted) {
        setState(() {});
      }
      // .then((_) {
      //   if (!mounted) {
      //     return;
      //   }
      //   setState(() {});
      // });
    }
  }

  Future<void> _setVideoFile(XFile file) async {
    print('here');
    setState(() {
      _videoFile = file;
    });
    await initializeVideo();
    await _uploadFile();
  }

  Future initializeVideo() async {
    if (_videoFile == null) {
      return;
    }

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      _videoFile!.path,
      subtitles: [],
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        looping: true,
        aspectRatio: 9 / 16,
        fit: BoxFit.cover,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
        placeholder: Center(
          child: CircularProgressIndicator(),
          // Text(
          //   'Broken',
          //   style: TextStyle(
          //     color: Colors.white,
          //   ),
          // ),
        ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    _betterPlayerController!.addEventsListener((event) {
      print("Better player event: ${event.betterPlayerEventType}");
      if (mounted && _betterPlayerController != null) {
        setState(() {});
      }
    });

    _betterPlayerController!.videoPlayerController?.addListener(() {
      if (mounted && _betterPlayerController != null) {
        setState(() {});
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  void toggleVideo() {
    print('toggle');
    // if (_betterPlayerController == null) {
    //   return;
    // }
    // _betterPlayerController!.value.isPlaying
    //     ? _betterPlayerController!.pause()
    //     : _betterPlayerController!.play();

    setState(() {});
  }

  Future onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
    );

    // If the controller is updated then update the UI.
    _cameraController!.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController!.value.hasError) {
        print('Camera error ${_cameraController!.value.errorDescription}');
      }
    });

    try {
      await _cameraController!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future _onResetPressed() async {
    // _cameraController = null;
    // initCamera();
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );
    selectedContacts.reset();

    setState(() {
      _isResetting = true;
    });

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

    setState(() {
      _betterPlayerController = null;
      _videoFile = null;
      _uploadCompleted = false;
      _sendPressed = false;
      _videoDoc = FirebaseFirestore.instance.collection('videos').doc();
      _progress = 0;
      _isResetting = false;
    });
  }

  double _getVideoDuration() {
    double? duration = (_betterPlayerController!
        .videoPlayerController?.value.duration!.inMilliseconds
        .toDouble());
    if (duration != null) {
      return double.parse((duration / 1000).toStringAsFixed(2));
    } else {
      return 0.0;
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
      ..endPoint = json['url']
      ..file = File(_videoFile!.path)
      ..onProgress = (double progress) {
        if (_upchunk != null && _videoFile == null) {
          _upchunk!.stop();
        }
        setState(() {
          _progress = progress.floor();
        });
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
          'duration': _getVideoDuration(),
          'views': 0,
          'deleted': false,
        });

        if (mounted) {
          setState(() {
            _uploadCompleted = true;
          });
        }

        if (_sendPressed) {
          print('UploadComplete -> Send');
          await _sendVM();
          // Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          print('UploadComplete -> No Send');
        }
      };

    _upchunk = UpChunk.createUpload(uploadOptions);

    // print(UpChunk.createUpload(uploadOptions));
  }

  Future<void> _onSendPressed() async {
    if (_videoFile == null) {
      return;
    }

    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );

    if (selectedContacts.isEmpty()) {
      SuperNavigator.handleContactsNavigation(
        context: context,
        primaryAction: _sendVM,
      );
      return;
    }

    setState(() {
      _sendPressed = true;
    });

    if (_uploadCompleted) {
      print('SendPressed -> Complete');
      await _sendVM();
    } else {
      print('SendPressed -> Incomplete');
    }
  }

  Future _sendVM() async {
    setState(() {
      _sendPressed = true;
    });
    final superuser = Provider.of<Superuser?>(context, listen: false);
    final connections = Provider.of<List<Connection>>(context, listen: false);
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );

    if (superuser == null) {
      return;
    }

    final analytics = Provider.of<FirebaseAnalytics>(
      context,
      listen: false,
    );

    Connection connection = await ConnectionService().getOrCreateConnection(
      currentUserId: superuser.id,
      selectedContacts: selectedContacts,
      connections: connections,
      analytics: analytics,
    );
    await _videoDoc.update({
      'connectionId': connection.id,
    });

    analytics.logEvent(
      name: 'vm_sent',
      parameters: <String, dynamic>{
        'id': _videoDoc.id,
        'senderId': superuser.id,
        'connectionId': connection.id,
        'duration': _getVideoDuration(),
      },
    );

    selectedContacts.reset();
    Navigator.of(context).popUntil((route) => route.isFirst);

    if (connection.phoneNumberNameMap.isNotEmpty) {
      String phone = connection.phoneNumberNameMap.keys.first;

      if (Platform.isAndroid) {
        String uri =
            'sms:$phone?body=Hey%20I%20just%20sent%20you%20a%20VM%20in%20Superconnector,%20get%20the%20app%20so%20we%20can%20VM%20each%20other%20faster%20https://www.superconnector.com/';
        await launch(uri);
      } else if (Platform.isIOS) {
        // iOS
        String uri =
            'sms:$phone&body=Hey%20I%20just%20sent%20you%20a%20VM%20in%20Superconnector,%20get%20the%20app%20so%20we%20can%20VM%20each%20other%20faster%20https://www.superconnector.com/';
        await launch(uri);
      }
    }
    return;
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addObserver(this);

    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    initCamera();
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

  void _showCameraException(CameraException e) {
    print('Error: ${e.code}\n${e.description}');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool shouldShowVideo = false;
    double? aspectRatio;
    bool? isPlaying = false;

    if (_betterPlayerController != null) {
      bool? isInitialized = _betterPlayerController!.isVideoInitialized();
      shouldShowVideo = isInitialized != null && isInitialized;
      aspectRatio = _betterPlayerController!.getAspectRatio();
      isPlaying = _betterPlayerController!.isPlaying();
    }

    return GestureDetector(
      onTap: () {
        print('Record container');
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              alignment: Alignment.center,
              children: [
                // Camera preview for recording VM
                if (_cameraController != null &&
                    _cameraController!.value.isInitialized &&
                    !shouldShowVideo)
                  CameraPreviewContainer(
                    cameraController: _cameraController!,
                    animationController: _animationController,
                    ratio: size.aspectRatio,
                    setVideoFile: _setVideoFile,
                    setIsRecording: (isRecording) {
                      setState(() {
                        _isRecording = isRecording;
                      });
                    },
                    isResetting: _isResetting,
                  ),

                // Video player after VM recorded
                if (shouldShowVideo)
                  // BetterPlayerMultipleGestureDetector(
                  //   child: AspectRatio(
                  //     aspectRatio: 16 / 9,
                  //     child: BetterPlayer(controller: _betterPlayerController!),
                  //   ),
                  //   onTap: () {
                  //     print("Tap!");
                  //   },
                  // ),
                  Stack(
                    children: [
                      Transform.scale(
                        scale:
                            aspectRatio! / (size.width / constraints.maxHeight),
                        child: BetterPlayerMultipleGestureDetector(
                          onTap: () {
                            _videoPlayerHelper
                                .toggleVideo(_betterPlayerController);
                          },
                          child: AspectRatio(
                            aspectRatio: aspectRatio,
                            child: BetterPlayer(
                              controller: _betterPlayerController!,
                            ),
                          ),
                        ),
                        // VideoPlayer(_betterPlayerController!),
                      ),
                      Positioned.fill(
                        bottom: 50.0,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _videoPlayerHelper
                                .toggleVideo(_betterPlayerController);
                          },
                          child: Container(
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: isPlaying != null && !isPlaying
                                  ? Image.asset(
                                      'assets/images/authenticated/record/play-button.png',
                                      width: 80.0,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                RecordOverlay(
                  isRecording: _isRecording,
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
