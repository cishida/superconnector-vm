import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/providers/camera_provider.dart';

class CameraIcon extends StatelessWidget {
  const CameraIcon({
    Key? key,
    required this.imageName,
    required this.title,
    required this.onPress,
    this.width = 22.0,
  }) : super(key: key);

  final String imageName;
  final String title;
  final Function onPress;
  final double width;

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(
      context,
    );

    FlashMode flashMode = FlashMode.auto;

    if (title == 'Flash' && cameraProvider.cameraController == null) {
      return Container();
    }

    if (cameraProvider.cameraController != null) {
      flashMode = cameraProvider.cameraController!.value.flashMode;
    }

    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w900,
      height: 0.0,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPress(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 12.0,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: (title == 'Flash' ? 8.0 : 0.0),
                  ),
                  child: Image.asset(
                    imageName,
                    width: width,
                  ),
                ),
                if (title == 'Flash' && flashMode == FlashMode.always)
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Image.asset(
                      'assets/images/authenticated/record/camera-menu-check.png',
                      width: 9.0,
                    ),
                  ),
                if (title == 'Flash' && flashMode == FlashMode.auto)
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Text(
                      'A',
                      style: textStyle,
                    ),
                  ),
                if (title == 'Flash' && flashMode == FlashMode.off)
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Text(
                      'X',
                      style: textStyle,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 4.0,
                // bottom: 24.0,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
