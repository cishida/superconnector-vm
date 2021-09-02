import 'package:flutter/material.dart';

class BottomSheetTab extends StatelessWidget {
  const BottomSheetTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40.0,
        height: 6.0,
        margin: const EdgeInsets.only(top: 27.0, bottom: 15.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.30),
          borderRadius: BorderRadius.circular(3.0),
        ),
      ),
    );
  }
}
