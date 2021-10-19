import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class EmptyImage extends StatelessWidget {
  final double size;

  const EmptyImage({
    Key? key,
    required this.size,
    this.isReversed = false,
  }) : super(key: key);

  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    if (isReversed) {
      return Image.asset(
        'assets/images/authenticated/empty-contact-photo.png',
        height: size,
        width: size,
        color: ConstantColors.navEmptyImage,
      );
    }
    return Image.asset(
      isReversed
          ? 'assets/images/authenticated/empty-contact-photo.png'
          : 'assets/images/authenticated/photo-placeholder.png',
      height: size,
      width: size,
    );
  }
}
