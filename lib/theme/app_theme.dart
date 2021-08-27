import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

ThemeData appTheme() {
  BorderRadius borderRadius = BorderRadius.circular(36);

  return ThemeData(
    primaryColor: ConstantColors.PRIMARY,
    fontFamily: 'SourceSansPro',
    brightness: Brightness.light,
    errorColor: ConstantColors.ERROR_RED,
    textTheme: TextTheme(
      button: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
      headline6: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        color: ConstantColors.DARK_TEXT,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(.5),
      ),
    ),
    // accentColor: Colors.orange,
    // hintColor: Colors.white,
    // dividerColor: Colors.white,
    // buttonColor: Colors.white,
    // scaffoldBackgroundColor: Colors.black,
    // canvasColor: Colors.black,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: borderRadius,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: ConstantColors.PRIMARY,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: ConstantColors.PRIMARY,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          width: 2.0,
          color: ConstantColors.ERROR_RED,
        ),
      ),
    ),
  );
}
