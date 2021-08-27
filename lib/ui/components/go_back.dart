import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class GoBack extends StatelessWidget {
  const GoBack({
    Key? key,
    this.action,
  }) : super(key: key);

  final Function? action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (action != null) {
          action!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 26.0,
          right: 26.0,
          top: 22.0,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 3.0,
              ),
              child: Image.asset(
                'assets/images/authenticated/arrow-icon.png',
                width: 18.0,
                height: 13.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(
                'Go back',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: ConstantColors.PRIMARY,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
