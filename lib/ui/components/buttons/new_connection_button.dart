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
    return Container(
      width: 64.0,
      height: 64.0,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor:
              isInverted ? Colors.white : ConstantColors.FAB_BACKGROUND,
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
