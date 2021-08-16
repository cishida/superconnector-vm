import 'package:flutter/material.dart';

class VideoTime extends StatelessWidget {
  VideoTime({
    Key? key,
    required this.duration,
    required this.position,
    required this.style,
  }) : super(key: key);

  final Duration duration;
  final Duration position;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final int secondsLeftInVideo = (duration - position).inSeconds;
    final String videoTime = '0:' +
        (secondsLeftInVideo < 10 ? '0' : '') +
        secondsLeftInVideo.toString();
    return Text(
      videoTime,
      style: style,
    );
  }
}
