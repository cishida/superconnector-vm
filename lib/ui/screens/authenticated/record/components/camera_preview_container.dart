import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';

class CameraPreviewContainer extends StatefulWidget {
  const CameraPreviewContainer({
    Key? key,
    required this.cameraController,
    required this.animationController,
    required this.setVideoFile,
    required this.ratio,
    required this.setIsRecording,
    required this.constraints,
    this.isResetting = false,
  }) : super(key: key);

  final CameraController cameraController;
  final AnimationController animationController;
  final Function setVideoFile;
  final double ratio;
  final Function(bool) setIsRecording;
  final bool isResetting;
  final BoxConstraints constraints;

  @override
  _CameraPreviewContainerState createState() => _CameraPreviewContainerState();
}

class _CameraPreviewContainerState extends State<CameraPreviewContainer> {
  bool _isRecording = false;
  bool _shouldShowOnboardingChip = true;
  Timer? _timer;
  int _currentVideoSeconds = 0;
  String? _filePath;

  @override
  void initState() {
    super.initState();

    _initializeDirectory();
  }

  Future _initializeDirectory() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/superconnector/videos';
    await Directory(dirPath).create(recursive: true);
    if (mounted) {
      setState(() {
        _filePath = '$dirPath/${timestamp()}.mp4';
      });
    }
  }

  void _showCameraException(CameraException e) {
    print('Error: ${e.code}\n${e.description}');
  }

  // void _onVideoRecordButtonPressed() {
  //   startVideoRecording().then((String? filePath) {
  //     if (filePath != null) {
  //       widget.setVideoFile(filePath);
  //       // _videoFile = XFile(filePath);
  //     }
  //     if (mounted) setState(() {});
  //   });
  // }

  Future _onStopButtonPressed() async {
    if (_timer == null) {
      return;
    }

    _timer!.cancel();
    return stopVideoRecording().then((_) {
      widget.setIsRecording(false);
      if (mounted)
        setState(() {
          _isRecording = false;
        });
    });
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String?> startVideoRecording() async {
    if (!widget.cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }

    if (widget.cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      widget.cameraController.startVideoRecording();

      widget.setIsRecording(true);
      if (mounted) {
        setState(() {
          _isRecording = true;
        });
      }

      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_currentVideoSeconds >=
              ConstantValues.VIDEO_TIME_LIMIT +
                  ConstantValues.VIDEO_OVERFLOW_LIMIT) {
            _onStopButtonPressed();
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

  Future<void> stopVideoRecording() async {
    if (!widget.cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      XFile videoFile = await widget.cameraController.stopVideoRecording();
      widget.setVideoFile(videoFile);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isResetting || !widget.cameraController.value.isInitialized) {
      return Container();
    }

    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTapDown: (_) async {
        widget.animationController.forward();
        await startVideoRecording();
        // await HapticFeedback.mediumImpact();
        setState(() {
          _shouldShowOnboardingChip = false;
        });
      },
      onTapUp: (_) async {
        if (widget.animationController.status == AnimationStatus.forward) {
          widget.animationController.stop();
        }

        await _onStopButtonPressed();
        // HapticFeedback.lightImpact();
      },
      onTapCancel: () async {
        if (widget.animationController.status == AnimationStatus.forward) {
          widget.animationController.stop();
        }

        await _onStopButtonPressed();
      },
      child: Container(
        height: widget.constraints.maxHeight,
        width: widget.constraints.maxWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.cameraController.value.isInitialized &&
                !widget.isResetting)
              Transform.scale(
                scale: widget.ratio /
                    (widget.constraints.maxWidth /
                        widget.constraints.maxHeight),
                child: CameraPreview(widget.cameraController),
              ),
            // Positioned(
            //   bottom: 52.5,
            //   child: Container(
            //     width: 75.0,
            //     height: 75.0,
            //     child: CircularProgressIndicator(
            //       color: Colors.transparent,
            //       strokeWidth: 4.0,
            //       backgroundColor: Colors.transparent,
            //       value: widget.animationController.value,
            //       valueColor: AlwaysStoppedAnimation<Color>(
            //         Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                child: LinearProgressIndicator(
                  color: Colors.transparent,
                  minHeight: 4.0,
                  backgroundColor: Colors.transparent,
                  value: widget.animationController.value,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 0.0,
            //   child: Container(
            //     width: size.width,
            //     child: GradientProgressIndicator(
            //       gradient: LinearGradient(
            //         colors: [
            //           Color(0xFF0AD3FF),
            //           Color(0xFFA132F5),
            //           // Color(0xFFF46F66),
            //           // Color(0xFFF1943B),
            //         ],
            //       ),
            //       value: widget.animationController.value,
            //       // Gradients.buildGradient(begin, end, colors),
            //       // value: 0.65,
            //     ),
            //   ),
            // ),

            Positioned(
              bottom: 93.0,
              child: AnimatedOpacity(
                opacity: _isRecording ? 1.0 : 0.0,
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
                opacity: !_isRecording && _shouldShowOnboardingChip ? 1.0 : 0.0,
                duration: const Duration(
                  milliseconds: 100,
                ),
                child: Image.asset(
                  'assets/images/authenticated/record/record-button.png',
                  width: 80.0,
                ),
              ),
            ),
            // if (_shouldShowOnboardingChip)
            Positioned.fill(
              bottom: 39.0,
              left: 0.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedOpacity(
                  opacity:
                      !_isRecording && _shouldShowOnboardingChip ? 1.0 : 0.0,
                  duration: const Duration(
                    milliseconds:
                        ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
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
                      'Tap and hold to record (${ConstantValues.VIDEO_TIME_LIMIT.toString()}s)',
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
            Positioned.fill(
              bottom: 39.0,
              left: 0.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedOpacity(
                  opacity: _isRecording &&
                          ConstantValues.VIDEO_TIME_LIMIT -
                                  _currentVideoSeconds >
                              0
                      ? 1.0
                      : 0.0,
                  duration: const Duration(
                    milliseconds:
                        ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
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
                      '${(ConstantValues.VIDEO_TIME_LIMIT - _currentVideoSeconds).toString()} remaining',
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
            Positioned.fill(
              bottom: 39.0,
              left: 0.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedOpacity(
                  opacity: _isRecording &&
                          ConstantValues.VIDEO_TIME_LIMIT -
                                  _currentVideoSeconds <=
                              0
                      ? 1.0
                      : 0.0,
                  duration: const Duration(
                    milliseconds:
                        ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      // color: Colors.white.withOpacity(.20),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/authenticated/overflow-background.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      '${((ConstantValues.VIDEO_TIME_LIMIT + ConstantValues.VIDEO_OVERFLOW_LIMIT) - _currentVideoSeconds).toString()} overflow',
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
        ),
      ),
    );
  }
}
