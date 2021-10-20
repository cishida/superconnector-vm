import 'package:flutter/material.dart';

class VMConnectionTile extends StatefulWidget {
  const VMConnectionTile({
    Key? key,
    required this.onPressed,
    this.invertGradient = false,
    this.isGrid = false,
  }) : super(key: key);

  final Function onPressed;
  final bool invertGradient;
  final bool isGrid;

  @override
  State<VMConnectionTile> createState() => _VMConnectionTileState();
}

class _VMConnectionTileState extends State<VMConnectionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return

        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () => onPressed(),
        InkWell(
      onTap: () {
        setState(() {
          _pressed = true;
        });
        widget.onPressed();
        setState(() {
          _pressed = false;
        });
      },
      onTapDown: (details) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        Future.delayed(Duration(milliseconds: 100))
            .then((value) => setState(() {
                  _pressed = false;
                }));
      },
      child: Container(
        height: widget.isGrid ? double.infinity : 146.0,
        width: widget.isGrid ? double.infinity : 110.0,
        margin: EdgeInsets.only(
          right: widget.isGrid ? 0.0 : 1.0,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.isGrid ? 3.0 : 6.0),
                child: Image.asset(
                  'assets/images/authenticated/initial-record-background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Image.asset(
                  'assets/images/authenticated/bottom_nav/bottom-nav-camera.png',
                  width: 40.0,
                ),
              ),
            ),
            if (_pressed)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Container(
                    color: Colors.black.withOpacity(.2),
                    child: Center(
                      child: Container(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
