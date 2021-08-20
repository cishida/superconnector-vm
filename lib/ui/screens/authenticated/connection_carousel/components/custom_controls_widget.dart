import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class CustomControlsWidget extends StatefulWidget {
  final BetterPlayerController? controller;

  const CustomControlsWidget({Key? key, this.controller}) : super(key: key);

  @override
  _CustomControlsWidgetState createState() => _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: InkWell(
        onTap: () {
          setState(() {
            if (widget.controller!.isPlaying()!)
              widget.controller!.pause();
            else
              widget.controller!.play();
          });
        },
      ),
    );
  }
}
