import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';

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
    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

    // if (isImage && cameraHandler.decodedImage != null) {
    //   final aspect = constraints.maxWidth / constraints.maxHeight;
    //   var scale = aspect *
    //       (cameraHandler.decodedImage!.height /
    //           cameraHandler.decodedImage!.width);
    //   // to prevent scaling down, invert the value
    //   if (scale < 1) scale = 1 / scale;
    //   return Transform.scale(
    //     scale: scale,
    //     child: Center(
    //       child: child,
    //     ),
    //   );
    // } else {
    if (cameraHandler.cameraController == null) {
      return Container();
    }

    var camera = cameraHandler.cameraController!.value;
    final aspect = constraints.maxWidth / constraints.maxHeight;

    if (!camera.isInitialized) {
      return Container();
    }

    var scale = aspect * camera.aspectRatio;
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
