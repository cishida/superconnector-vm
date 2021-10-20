import 'package:flutter/material.dart';

class CameraIcon extends StatelessWidget {
  const CameraIcon({
    Key? key,
    required this.imageName,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  final String imageName;
  final String title;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPress(),
      child: Column(
        children: [
          Image.asset(
            imageName,
            width: 24.0,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
              bottom: 26.0,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
