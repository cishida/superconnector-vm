import 'package:flutter/material.dart';

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
            Image.asset(
              imageName,
              width: width,
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
