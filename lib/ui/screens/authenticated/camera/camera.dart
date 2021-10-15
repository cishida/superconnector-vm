import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/core/utils/video/camera_utility.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/record_overlay.dart';

class Camera extends StatefulWidget {
  const Camera({
    Key? key,
  }) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  // CameraController? _cameraController;
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  String? _path;
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
    super.initState();
    availableCameras().then((availableCameras) async {
      _cameras = availableCameras;

      await initCamera();
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  Widget cameraPreview() {
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CameraPreview(_controller!),
    );
  }

  Widget camera(context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Transform.scale(
              scale: 9 / 16,
              child: cameraPreview(),
            ), //cameraPreview(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ConstantColors.DARK_BLUE,
        body: Stack(
          children: [
            camera(context),
            CameraOptions(
              toggleCamera: _toggleCameraLens,
            ),
            CameraOverlay(
              controller: _controller!,
              currentVideoSeconds: _currentVideoSeconds,
            ),
          ],
        ),
      ),
    );
  }

  // void _showCameraException(CameraException e) {
  //   String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
  //   print(errorText);

  //   Fluttertoast.showToast(
  //       msg: 'Error: ${e.code}\n${e.description}',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white
  //   );
  // }
}

class CameraOptions extends StatelessWidget {
  const CameraOptions({
    Key? key,
    required this.toggleCamera,
  }) : super(key: key);

  final Function toggleCamera;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 65.0,
      right: 0.0,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(
          milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CameraIcon(
                title: 'Flip',
                imageName:
                    'assets/images/authenticated/record/camera-flip-icon.png',
                onPress: () => toggleCamera(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraOverlay extends StatelessWidget {
  const CameraOverlay({
    Key? key,
    required this.controller,
    required this.currentVideoSeconds,
  }) : super(key: key);

  final CameraController controller;
  final int currentVideoSeconds;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 71.0,
          left: 50.0,
          right: 50.0,
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              opacity: controller.value.isRecordingVideo ? 1.0 : 0.0,
              duration: const Duration(
                milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: Colors.white.withOpacity(.20),
                ),
                child: Text(
                  '${(ConstantValues.VIDEO_TIME_LIMIT - currentVideoSeconds).toString()} remaining',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 93.0,
          child: AnimatedOpacity(
            opacity: controller.value.isRecordingVideo ? 1.0 : 0.0,
            duration: const Duration(
              milliseconds: 100,
            ),
            child: Image.asset(
              'assets/images/authenticated/record/recording-button.png',
              width: 80.0,
            ),

            //  Image.asset(
            //   _isRecording
            //       ? 'assets/images/authenticated/record/recording-button.png'
            //       : 'assets/images/authenticated/record/record-button.png',
            //   width: 80.0,
            // ),
          ),
        ),
        Positioned(
          bottom: 93.0,
          child: AnimatedOpacity(
            opacity: !controller.value.isRecordingVideo ? 1.0 : 0.0,
            duration: const Duration(
              milliseconds: 100,
            ),
            child: Image.asset(
              'assets/images/authenticated/record/record-button.png',
              width: 80.0,
            ),
          ),
        ),
        Positioned.fill(
          bottom: 39.0,
          left: 0.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: !controller.value.isRecordingVideo ? 1.0 : 0.0,
              duration: const Duration(
                milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: Colors.white.withOpacity(.20),
                ),
                child: Text(
                  'Tap and hold to record',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
