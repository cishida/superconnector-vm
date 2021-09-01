import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

ThemeData appTheme() {
  BorderRadius borderRadius = BorderRadius.circular(36);

  return ThemeData(
    primaryColor: ConstantColors.PRIMARY,
    fontFamily: 'SourceSansPro',
    brightness: Brightness.light,
    errorColor: ConstantColors.ERROR_RED,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    textTheme: TextTheme(
      button: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
      headline5: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        color: ConstantColors.DARK_TEXT,
      ),
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        letterSpacing: .15,
      ),
      subtitle1: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(.5),
        height: 24 / 17,
      ),
      subtitle2: TextStyle(
        color: Colors.black.withOpacity(0.5),
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        letterSpacing: .15,
        height: 24 / 17,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 22 / 16,
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
