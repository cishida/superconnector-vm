import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class Underline extends StatelessWidget {
  const Underline({
    Key? key,
    this.margin = const EdgeInsets.all(0),
    this.color,
  }) : super(key: key);

  final EdgeInsets margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      color: color ?? ConstantColors.ED_GRAY,
      margin: margin,
    );
  }
}
