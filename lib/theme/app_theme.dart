import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: ConstantColors.PRIMARY,
    fontFamily: 'SourceSansPro',
    brightness: Brightness.light,
    errorColor: ConstantColors.ERROR_RED,
    // accentColor: Colors.orange,
    // hintColor: Colors.white,
    // dividerColor: Colors.white,
    // buttonColor: Colors.white,
    // scaffoldBackgroundColor: Colors.black,
    // canvasColor: Colors.black,
  );
}
