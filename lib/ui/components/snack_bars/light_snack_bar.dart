import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class LightSnackBar {
  static SnackBar createSnackBar({
    required String text,
    // double bottomMargin = 0.0,
    // double sideMargin = 8.0,
    int seconds = 2,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.only(
      //   bottom: 50,
      //   left: sideMargin,
      //   right: sideMargin,
      // ),
      backgroundColor: Colors.white,
      // behavior: SnackBarBehavior.floating,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(3),
      //   ),
      // ),
      duration: Duration(
        seconds: seconds,
      ),
      content: Padding(
        padding: const EdgeInsets.all(
          4.0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: ConstantColors.PRIMARY,
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            fontFamily: 'SourceSansPro',
          ),
        ),
      ),
    );
  }
}
