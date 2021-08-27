import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.backgroundColor = ConstantColors.OFF_WHITE,
    this.brightness = Brightness.light,
  }) : super(key: key);

  final Color backgroundColor;
  final Brightness brightness;

  @override
  Size get preferredSize => Size(double.infinity, 0.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      brightness: brightness,
      elevation: 0.0,
      toolbarHeight: 0.0,
    );
  }
}
