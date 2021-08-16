import 'package:flutter/material.dart';

class EmptyImage extends StatelessWidget {
  final double size;

  const EmptyImage({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/authenticated/photo-placeholder.png',
      height: size,
      width: size,
    );
  }
}
