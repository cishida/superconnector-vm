import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class RecordBottomNav extends StatelessWidget {
  const RecordBottomNav({
    Key? key,
    required this.onResetPressed,
    required this.onSendPressed,
    this.shouldShowSendVM = false,
  }) : super(key: key);

  final Function onResetPressed;
  final Function onSendPressed;
  final bool shouldShowSendVM;

  @override
  Widget build(BuildContext context) {
    TextStyle bottomNavStyle = TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    );

    return BottomAppBar(
      color: ConstantColors.DARK_BLUE,
      child: Container(
        height: 55.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onResetPressed(),
              child: Text(
                'Reset',
                style: bottomNavStyle,
              ),
            ),
            if (shouldShowSendVM)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSendPressed(),
                child: Image.asset(
                  'assets/images/authenticated/record/send-vm-button.png',
                  width: 46.0,
                ),
                // shouldShowSendVM
                //     ? Container(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 15.0,
                //           vertical: 6.0,
                //         ),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(32.0),
                //           color: ConstantColors.TURQUOISE,
                //         ),
                //         child: Text(
                //           'Send Video',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             color: ConstantColors.DARK_BLUE,
                //             fontSize: 18.0,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       )
                //     : Text(
                //         'Send Video',
                //         style: bottomNavStyle,
                //       ),
              ),
          ],
        ),
      ),
    );
  }
}
