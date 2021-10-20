import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraToggle extends StatelessWidget {
  const CameraToggle({
    Key? key,
    required this.controller,
    required this.toggleCamera,
  }) : super(key: key);

  final CameraController? controller;
  final Function toggleCamera;

  @override
  Widget build(BuildContext context) {
    bool _isRecording =
        controller != null && controller!.value.isRecordingVideo;

    return Positioned(
      bottom: 104.0,
      child: AnimatedOpacity(
        opacity: !_isRecording ? 1.0 : 0.0,
        duration: const Duration(
          milliseconds: 100,
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 2 * (37.0 + 40 + (31 / 2))),
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => toggleCamera(),
            child: Image.asset(
              'assets/images/authenticated/record/camera-flip-icon.png',
              width: 31.0,
            ),
          ),
        ),
      ),
    );
  }
}
