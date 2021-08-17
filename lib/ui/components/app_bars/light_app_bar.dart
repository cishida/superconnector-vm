import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class LightAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LightAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size(double.infinity, 0.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ConstantColors.OFF_WHITE,
      brightness: Brightness.light,
      elevation: 0.0,
      toolbarHeight: 0.0,
    );
  }
}
