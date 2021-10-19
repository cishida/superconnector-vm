import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class GroupSelectionButton extends StatelessWidget {
  const GroupSelectionButton({
    Key? key,
    required this.onPressed,
    this.pressed = false,
  }) : super(key: key);

  final Function onPressed;
  final bool pressed;

  @override
  Widget build(BuildContext context) {
    //136 / 49
    return Container(
      width: 136.0,
      height: 49.0,
      child: ElevatedButton(
        child: pressed
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
            : Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 3.0,
                      right: 15.0,
                    ),
                    child: Image.asset(
                      'assets/images/authenticated/check-mark.png',
                      color: Colors.white,
                      width: 18.0,
                      height: 14.0,
                    ),
                  ),
                  Text(
                    'CONFIRM',
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                  ),
                ],
              ),
        style: ElevatedButton.styleFrom(
          primary: ConstantColors.PRIMARY,
          onPrimary: ConstantColors.OFF_WHITE,
          elevation: 5.0,
          minimumSize: Size(136, 49),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              25.0,
            ),
          ),
        ),
        onPressed: () => onPressed(),
      ),
    );
  }
}
