import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';

class CameraOptions extends StatelessWidget {
  const CameraOptions({
    Key? key,
    required this.toggleCamera,
    required this.controller,
  }) : super(key: key);

  final Function toggleCamera;
  final CameraController? controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 65.0,
      right: 0.0,
      child: AnimatedOpacity(
        opacity: controller == null || controller!.value.isRecordingVideo
            ? 0.0
            : 1.0,
        duration: const Duration(
          milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
        ),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: CameraIcon(
            //     title: 'Flip',
            //     imageName:
            //         'assets/images/authenticated/record/camera-flip-icon.png',
            //     onPress: () => toggleCamera(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
