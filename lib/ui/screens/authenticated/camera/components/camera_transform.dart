import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/providers/camera_provider.dart';

class CameraTransform extends StatelessWidget {
  const CameraTransform({
    Key? key,
    required this.constraints,
    this.isImage = false,
    required this.child,
  }) : super(key: key);

  final BoxConstraints constraints;
  final bool isImage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(
      context,
    );

    // if (isImage && cameraProvider.decodedImage != null) {
    //   final aspect = constraints.maxWidth / constraints.maxHeight;
    //   var scale = aspect *
    //       (cameraProvider.decodedImage!.height /
    //           cameraProvider.decodedImage!.width);
    //   // to prevent scaling down, invert the value
    //   if (scale < 1) scale = 1 / scale;
    //   return Transform.scale(
    //     scale: scale,
    //     child: Center(
    //       child: child,
    //     ),
    //   );
    // } else {
    double aspect = constraints.maxWidth / constraints.maxHeight;
    double scale = 0;
    double cameraAspect = 1.7777777;

    if (cameraProvider.cameraController != null) {
      var camera = cameraProvider.cameraController!.value;

      if (!camera.isInitialized) {
        return Container();
      }
      cameraAspect = camera.aspectRatio;
    }

    scale = aspect * cameraAspect;
    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: child,
      ),
    );
  }
  // }
}
