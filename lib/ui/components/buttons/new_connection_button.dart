import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class NewConnectionButton extends StatelessWidget {
  const NewConnectionButton({
    Key? key,
    required this.onPressed,
    this.isInverted = false,
  }) : super(key: key);

  final Function onPressed;
  final bool isInverted;

  @override
  Widget build(BuildContext context) {
    double radius = 32.0;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: isInverted
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                radius,
              ),
            )
          : BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/images/authenticated/gradient-background.png',
                ),
              ),
              borderRadius: BorderRadius.circular(
                radius,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.3),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 2.0),
                )
              ],
            ),
      child: FittedBox(
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.add,
            color: isInverted ? ConstantColors.FAB_BACKGROUND : Colors.white,
          ),
          onPressed: () => onPressed(),
        ),
      ),
    );
  }
}
