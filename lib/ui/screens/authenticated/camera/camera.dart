import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/core/utils/video/camera_utility.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_options.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_overlay.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/record_overlay.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/video_preview_container/video_preview_container.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;
import 'dart:ui' as ui;

class Camera extends StatefulWidget {
  const Camera({
    Key? key,
    this.connection,
  }) : super(key: key);

  final Connection? connection;

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  String? _filePath;
  Timer? _timer;
  int _currentVideoSeconds = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future initCamera({
    CameraDescription? description,
  }) async {
    if (_cameras.length > 0) {
      _controller = await CameraUtility.initializeController(
        description ??
            _cameras.firstWhere((description) =>
                description.lensDirection == CameraLensDirection.front),
        listener: () {
          if (mounted) {
            setState(() {});
          }

          if (_controller!.value.hasError) {
            print('Camera error ${_controller!.value.errorDescription}');
          }
        },
      );
    } else {
      print('No camera available');
    }
    if (mounted) {
      setState(() {});
    }
  }

  // Future _initializeDirectory() async {
  //   final Directory extDir = await getApplicationDocumentsDirectory();
  //   final String dirPath = '${extDir.path}/Movies/superconnector/videos';
  //   await Directory(dirPath).create(recursive: true);
  //   if (mounted) {
  //     setState(() {
  //       _filePath =
  //           '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}.mp4';
  //     });
  //   }
  // }

  void _showCameraException(CameraException e) {
    print('Error: ${e.code}\n${e.description}');
  }

  void _toggleCameraLens() {
    if (_controller == null) {
      return;
    }

    final lensDirection = _controller!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    initCamera(description: newDescription);
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addObserver(this);
    super.initState();

    availableCameras().then((availableCameras) async {
      _cameras = availableCameras;

      await initCamera();
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: ConstantValues.VIDEO_TIME_LIMIT * 1000,
      ),
    );
    _animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );
    selectedContacts.reset();
  }

  Future<String?> startVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }

    if (_controller!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await _controller!.startVideoRecording();

      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_currentVideoSeconds >=
              ConstantValues.VIDEO_TIME_LIMIT +
                  ConstantValues.VIDEO_OVERFLOW_LIMIT) {
            _stopVideoRecording();
          } else {
            if (mounted) {
              setState(() {
                _currentVideoSeconds = _currentVideoSeconds + 1;
              });
            }
          }
        },
      );
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return _filePath;
  }

  Future _onResetPressed() async {
    _animationController.reset();
    print('Reset');
  }

  Future onNewCameraSelected(
    CameraDescription cameraDescription,
  ) async {
    print('here?');
    if (_controller != null) {
      CameraController temp = _controller!;
      if (mounted) {
        setState(() {
          _controller = null;
        });
      }
      await temp.dispose();
    }
    await initCamera();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      XFile videoFile = await _controller!.stopVideoRecording();
      final uint8list = await thumb.VideoThumbnail.thumbnailData(
        video: videoFile.path,
        // imageFormat: thumb.ImageFormat.JPEG,
        // maxWidth: size.width.toInt(),
        // maxHeight: size.height.toInt(),
        quality: 1,
      );

      Widget blurredThumb = uint8list != null
          ? Container(
              color: Colors.transparent,
              child: Center(
                child: Stack(
                  children: [
                    Image.memory(
                      uint8list,
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
            )
          : Container();
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              VideoPreviewContainer(
            connection: widget.connection,
            videoFile: videoFile,
            blurredThumb: blurredThumb,
            onReset: _onResetPressed,
          ),
          transitionDuration: Duration.zero,
        ),
      );

      await onNewCameraSelected(_controller!.description);

      if (_timer != null) {
        _timer!.cancel();
      }

      if (mounted) {
        setState(() {
          _currentVideoSeconds = 0;
        });
      }
    } on CameraException catch (e) {
      print('Camera exception');
      _showCameraException(e);
      return null;
    }
  }

  // Widget camera(context) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       return
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: ConstantColors.DARK_BLUE,
            body: Stack(
              children: [
                Listener(
                  onPointerDown: (_) async {
                    _animationController.forward();
                    await startVideoRecording();
                  },
                  onPointerUp: (_) async {
                    if (_animationController.status ==
                        AnimationStatus.forward) {
                      _animationController.stop();
                    }
                    await _stopVideoRecording();
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: Transform.scale(
                            scale: 9 /
                                14 /
                                (constraints.maxWidth / constraints.maxHeight),
                            child: AspectRatio(
                              aspectRatio: (constraints.maxWidth /
                                  constraints.maxHeight),
                              child: OverflowBox(
                                alignment: Alignment.topCenter,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Container(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    child: Stack(
                                      children: <Widget>[
                                        CameraPreview(_controller!),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ), //cameraPreview(),
                        ),
                      ),
                      if (widget.connection != null)
                        Positioned(
                          top: 71.0,
                          left: 0.0,
                          child: ChevronBackButton(
                            color: Colors.white,
                            onBack: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),

                      CameraOverlay(
                        controller: _controller!,
                        currentVideoSeconds: _currentVideoSeconds,
                        connection: widget.connection,
                      ),
                      // Using mask over white progress indicator for gradient
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: constraints.maxWidth,
                          child: Stack(
                            children: [
                              ShaderMask(
                                shaderCallback: (rect) {
                                  return LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: [
                                      0.0,
                                      .33,
                                      .66,
                                      1.0,
                                    ],
                                    colors: [
                                      Color(0xFF0AD3FF),
                                      Color(0xFFA132F5),
                                      Color(0xFFF46F66),
                                      Color(0xFFF1943B),
                                    ],
                                  ).createShader(rect);
                                },
                                child: LinearProgressIndicator(
                                  color: Colors.transparent,
                                  minHeight: 4.0,
                                  backgroundColor: Colors.transparent,
                                  value: _animationController.value,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CameraOptions(
                  toggleCamera: _toggleCameraLens,
                  controller: _controller,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
