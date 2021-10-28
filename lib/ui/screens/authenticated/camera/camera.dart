import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_overlay/camera_overlay.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_toggle.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_transform.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/image_preview_container/image_preview_container.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/video_preview_container/video_preview_container.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;

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
  // CameraController? _controller;
  List<CameraDescription> _cameras = [];
  String? _filePath;
  bool _pointerDown = false;
  Timer? _timer;
  int _currentVideoSeconds = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future initCamera({
    CameraDescription? description,
  }) async {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
      listen: false,
    );

    if (_cameras.length > 0) {
      // _controller = await CameraUtility.initializeController(
      //   description ??
      //       _cameras.firstWhere((description) =>
      //           description.lensDirection == CameraLensDirection.front),
      //   listener: () {
      //     if (mounted) {
      //       setState(() {});
      //     }

      //     if (_controller!.value.hasError) {
      //       print('Camera error ${_controller!.value.errorDescription}');
      //     }
      //   },
      // );

      var frontFacing = _cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);

      // if (cameraHandler.cameraController == null) {
      await cameraHandler.initCamera(
        description ?? frontFacing,
        listener: () {
          if (mounted) {
            setState(() {});
          }

          if (cameraHandler.cameraController!.value.hasError) {
            print(
                'Camera error ${cameraHandler.cameraController!.value.errorDescription}');
          }
        },
      );
      // cameraHandler.cameraController =
      //     await CameraUtility.initializeController(
      //   description ??
      //       _cameras.firstWhere((description) =>
      //           description.lensDirection == CameraLensDirection.front),
      //   listener: () {
      //     if (mounted) {
      //       setState(() {});
      //     }

      //     if (cameraHandler.cameraController!.value.hasError) {
      //       print(
      //           'Camera error ${cameraHandler.cameraController!.value.errorDescription}');
      //     }
      //   },
      // );
      // }
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

  Future _toggleCameraLens() async {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
      listen: false,
    );
    if (cameraHandler.cameraController == null) {
      return;
    }

    final lensDirection =
        cameraHandler.cameraController!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    await onNewCameraSelected(newDescription);

    // await initCamera(description: newDescription);
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

    // var selectedContacts = Provider.of<SelectedContacts>(
    //   context,
    //   listen: false,
    // );
    // selectedContacts.reset();
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance!.removeObserver(this);
  //   final cameraHandler = Provider.of<CameraHandler>(
  //     context,
  //     listen: false,
  //   );
  //   cameraHandler.disposeCamera();
  //   super.dispose();
  // }

  Future<String?> startVideoRecording() async {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
      listen: false,
    );

    if (cameraHandler.cameraController == null ||
        !cameraHandler.cameraController!.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }

    if (cameraHandler.cameraController!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    Future.delayed(
        Duration(
          milliseconds: ConstantValues.CAMERA_TAKE_PHOTO_LIMIT_MILLISECONDS,
        ), () async {
      try {
        // If holding down, start recording
        if (_pointerDown) {
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
          await cameraHandler.cameraController!.startVideoRecording();
        } else {
          // If let go, should take photo
          try {
            // Attempt to take a picture and then get the location
            // where the image file is saved.
            await cameraHandler.takePicture();
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    ImagePreviewContainer(
                  connection: widget.connection,
                  onReset: _onResetPressed,
                ),
                transitionDuration: Duration.zero,
              ),
            );

            // await onNewCameraSelected(
            //     cameraHandler.cameraController!.description);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        }
        setState(() {});
      } on CameraException catch (e) {
        _showCameraException(e);
        return null;
      }
    });

    return _filePath;
  }

  Future _onResetPressed() async {
    if (mounted) {
      final cameraHandler = Provider.of<CameraHandler>(
        context,
        listen: false,
      );

      if (_timer != null) {
        _timer!.cancel();
      }
      await cameraHandler.disposeCamera();
      await initCamera();
      _animationController.reset();

      setState(() {
        _currentVideoSeconds = 0;
        _pointerDown = false;
      });
    }
  }

  Future onNewCameraSelected(
    CameraDescription cameraDescription,
  ) async {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
      listen: false,
    );

    await cameraHandler.disposeCamera();
    await initCamera(
      description: cameraDescription,
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _stopVideoRecording() async {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
      listen: false,
    );

    if (cameraHandler.cameraController == null ||
        !cameraHandler.cameraController!.value.isRecordingVideo) {
      return null;
    }

    try {
      cameraHandler.videoFile =
          await cameraHandler.cameraController!.stopVideoRecording();
      final uint8list = await thumb.VideoThumbnail.thumbnailData(
        video: cameraHandler.videoFile!.path,
        timeMs: 250,
        // imageFormat: thumb.ImageFormat.JPEG,
        // maxWidth: size.width.toInt(),
        // maxHeight: size.height.toInt(),
        quality: 1,
      );

      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              VideoPreviewContainer(
            connection: widget.connection,
            blurredThumb: uint8list,
            onReset: _onResetPressed,
          ),
          transitionDuration: Duration.zero,
        ),
      );

      await onNewCameraSelected(cameraHandler.cameraController!.description);

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

  // Widget cameraWidget(
  //   BuildContext context,
  //   BoxConstraints constraints,
  // ) {
  //   final cameraHandler = Provider.of<CameraHandler>(
  //     context,
  //   );

  //   var camera = cameraHandler.cameraController!.value;
  //   // fetch screen size
  //   final aspect = constraints.maxWidth / constraints.maxHeight;

  //   // calculate scale depending on screen and camera ratios
  //   // this is actually size.aspectRatio / (1 / camera.aspectRatio)
  //   // because camera preview size is received as landscape
  //   // but we're calculating for portrait orientation
  //   var scale = aspect * camera.aspectRatio;

  //   // to prevent scaling down, invert the value
  //   if (scale < 1) scale = 1 / scale;

  //   return Transform.scale(
  //     scale: scale,
  //     child: Center(
  //       child: CameraPreview(
  //         cameraHandler.cameraController!,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

    if (cameraHandler.cameraController == null ||
        !cameraHandler.cameraController!.value.isInitialized) {
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
            backgroundColor: Colors.black,
            body: Stack(
              alignment: Alignment.center,
              children: [
                Listener(
                  onPointerDown: (PointerDownEvent event) async {
                    setState(() {
                      _pointerDown = true;
                    });
                    if (event.position.dy < 200) {
                      return;
                    }
                    // _animationController.forward();
                    await startVideoRecording();
                    setState(() {});
                  },
                  onPointerUp: (_) async {
                    setState(() {
                      _pointerDown = false;
                    });
                    // if (_animationController.status ==
                    //     AnimationStatus.forward) {
                    //   _animationController.stop();
                    // }
                    await _stopVideoRecording();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CameraTransform(
                        constraints: constraints,
                        child: CameraPreview(
                          cameraHandler.cameraController!,
                        ),
                      ),
                      // ClipRRect(
                      //   borderRadius: BorderRadius.only(
                      //     bottomLeft: Radius.circular(10),
                      //     bottomRight: Radius.circular(10),
                      //   ),
                      //   child: Center(
                      //     child: AspectRatio(
                      //       aspectRatio: 1 /
                      //           cameraHandler
                      //               .cameraController!.value.aspectRatio,
                      //       child:
                      //           CameraPreview(cameraHandler.cameraController!),
                      //     ),
                      //   ),

                      //   // Transform.scale(
                      //   //   scale: 9 /
                      //   //       14 /
                      //   //       (constraints.maxWidth /
                      //   //           constraints.maxHeight),
                      //   //   child: AspectRatio(
                      //   //     aspectRatio: (constraints.maxWidth /
                      //   //         constraints.maxHeight),
                      //   //     child: OverflowBox(
                      //   //       alignment: Alignment.topCenter,
                      //   //       child: FittedBox(
                      //   //         fit: BoxFit.fitHeight,
                      //   //         child: Container(
                      //   //           width: constraints.maxWidth,
                      //   //           height: constraints.maxHeight,
                      //   //           child: Stack(
                      //   //             children: <Widget>[
                      //   //               if (cameraHandler.cameraController !=
                      //   //                   null)
                      //   //                 AnimatedOpacity(
                      //   //                   opacity: cameraHandler
                      //   //                               .cameraController !=
                      //   //                           null
                      //   //                       ? 1.0
                      //   //                       : 0.0,
                      //   //                   duration: const Duration(
                      //   //                     milliseconds: 500,
                      //   //                   ),
                      //   //                   child: CameraPreview(
                      //   //                     cameraHandler.cameraController!,
                      //   //                   ),
                      //   //                 ),
                      //   //             ],
                      //   //           ),
                      //   //         ),
                      //   //       ),
                      //   //     ),
                      //   //   ),
                      //   // ),
                      // ),
                      if (widget.connection != null)
                        Positioned(
                          top: 71.0,
                          left: 0.0,
                          child: ChevronBackButton(
                            color: Colors.white,
                            onBack: () async {
                              await cameraHandler.disposeCamera();
                              Navigator.pop(context);
                            },
                          ),
                        ),

                      // Using mask over white progress indicator for gradient
                      // Positioned(
                      //   bottom: 0,
                      //   child: Container(
                      //     width: constraints.maxWidth,
                      //     child: Stack(
                      //       children: [
                      //         ShaderMask(
                      //           shaderCallback: (rect) {
                      //             return LinearGradient(
                      //               begin: Alignment.centerLeft,
                      //               end: Alignment.centerRight,
                      //               stops: [
                      //                 0.0,
                      //                 .33,
                      //                 .66,
                      //                 1.0,
                      //               ],
                      //               colors: [
                      //                 Color(0xFF0AD3FF),
                      //                 Color(0xFFA132F5),
                      //                 Color(0xFFF46F66),
                      //                 Color(0xFFF1943B),
                      //               ],
                      //             ).createShader(rect);
                      //           },
                      //           child: LinearProgressIndicator(
                      //             color: Colors.transparent,
                      //             minHeight: 6.0,
                      //             backgroundColor: Colors.transparent,
                      //             value: _animationController.value,
                      //             valueColor: AlwaysStoppedAnimation<Color>(
                      //               Colors.white,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // CameraOptions(
                //   toggleCamera: _toggleCameraLens,
                //   controller: cameraHandler.cameraController,
                // ),
                // CameraToggle(
                //   controller: cameraHandler.cameraController,
                //   toggleCamera: _toggleCameraLens,
                // ),
                CameraOverlay(
                  controller: cameraHandler.cameraController,
                  currentVideoSeconds: _currentVideoSeconds,
                  toggleCamera: _toggleCameraLens,
                  connection: widget.connection,
                  pointerDown: _pointerDown,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
