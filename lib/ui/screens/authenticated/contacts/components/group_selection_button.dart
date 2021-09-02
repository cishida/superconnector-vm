import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class GroupSelectionButton extends StatelessWidget {
  const GroupSelectionButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    //136 / 49
    return Container(
      width: 136.0,
      height: 49.0,
      child: ElevatedButton(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 3.0,
                right: 15.0,
              ),
              child: Image.asset(
                'assets/images/authenticated/check-mark.png',
                width: 18.0,
                height: 14.0,
              ),
            ),
            Text(
              'CONFIRM',
              style: Theme.of(context).textTheme.button!.copyWith(
                    color: ConstantColors.PRIMARY,
                    fontSize: 15.0,
                  ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
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
