import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class BarButton extends StatelessWidget {
  const BarButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = ConstantColors.PRIMARY,
    this.textColor = Colors.white,
  }) : super(key: key);

  final String title;
  final Function onPressed;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        title,
        style: Theme.of(context).textTheme.button!.copyWith(color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        onPrimary: backgroundColor.withOpacity(.8),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
      ),
      onPressed: () => onPressed(),
    );
  }
}
