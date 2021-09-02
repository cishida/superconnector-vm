import 'package:flutter/material.dart';

class VMConnectionTile extends StatelessWidget {
  const VMConnectionTile({
    Key? key,
    required this.onPressed,
    this.isGrid = false,
  }) : super(key: key);

  final Function onPressed;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPressed(),
      child: Container(
        height: isGrid ? double.infinity : 146.0,
        width: isGrid ? double.infinity : 110.0,
        margin: EdgeInsets.only(
          right: isGrid ? 0.0 : 1.0,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isGrid ? 3.0 : 6.0),
                child: Image.asset(
                  'assets/images/authenticated/vm-connection-gradient.png',
                  fit: BoxFit.cover,
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
