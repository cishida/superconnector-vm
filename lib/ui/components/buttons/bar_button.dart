import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class BarButton extends StatelessWidget {
  const BarButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = ConstantColors.PRIMARY,
    this.textColor = Colors.white,
    this.showLoading = false,
  }) : super(key: key);

  final String title;
  final Function onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: showLoading
          ? CollectionScaleTransition(
              children: <Widget>[
                Icon(
                  Icons.circle,
                  size: 8.0,
                  color: ConstantColors.PRIMARY,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 8.0,
                    color: ConstantColors.PRIMARY,
                  ),
                ),
                Icon(
                  Icons.circle,
                  size: 8.0,
                  color: ConstantColors.PRIMARY,
                ),
              ],
            )
          : Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: textColor),
            ),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        onPrimary: backgroundColor == Colors.white
            ? ConstantColors.PRIMARY.withOpacity(.1)
            : backgroundColor.withOpacity(.8),
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
