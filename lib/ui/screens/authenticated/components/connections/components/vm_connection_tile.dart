import 'package:flutter/material.dart';

class VMConnectionTile extends StatelessWidget {
  const VMConnectionTile({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPressed(),
      child: Container(
        height: 146.0,
        width: 110.0,
        margin: const EdgeInsets.only(
          right: 1.0,
        ),
        child: Stack(
          children: [
            Positioned(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.asset(
                  'assets/images/authenticated/vm_connection_gradient.png',
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Image.asset(
                  'assets/images/authenticated/add-button.png',
                  width: 26.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
