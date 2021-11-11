import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.backgroundColor = ConstantColors.OFF_WHITE,
    this.systemUiOverlayStyle = SystemUiOverlayStyle.light,
  }) : super(key: key);

  final Color backgroundColor;
  final SystemUiOverlayStyle systemUiOverlayStyle;

  @override
  Size get preferredSize => Size(double.infinity, 0.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      // brightness: brightness,
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      toolbarHeight: 0.0,
    );
  }
}
