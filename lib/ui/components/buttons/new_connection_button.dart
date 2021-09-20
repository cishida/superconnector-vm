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
    double radius = 24.0;

    return Container(
      width: 146,
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
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 25.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.add,
                  color:
                      isInverted ? ConstantColors.FAB_BACKGROUND : Colors.white,
                ),
              ),
              Text(
                'CONNECT',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.25,
                ),
              ),
            ],
          ),
        ),
        onPressed: () => onPressed(),
      ),
    );
  }
}
