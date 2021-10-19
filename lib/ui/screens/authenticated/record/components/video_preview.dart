import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/video/video_player_helper.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({
    Key? key,
    required this.aspectRatio,
    required this.betterPlayerController,
    required this.constraints,
  }) : super(key: key);

  final double? aspectRatio;
  final BetterPlayerController betterPlayerController;
  final BoxConstraints constraints;

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerHelper _videoPlayerHelper = VideoPlayerHelper();

  @override
  Widget build(BuildContext context) {
    if (widget.aspectRatio == null) {
      return Container(
        color: Colors.transparent,
      );
    }

    return Stack(
      children: [
        Transform.scale(
          scale: widget.aspectRatio! /
              (widget.constraints.maxWidth / widget.constraints.maxHeight),
          child: BetterPlayerMultipleGestureDetector(
            onTap: () {
              _videoPlayerHelper.toggleVideo(widget.betterPlayerController);
            },
            child: AspectRatio(
              aspectRatio: widget.aspectRatio!,
              child: BetterPlayer(
                controller: widget.betterPlayerController,
              ),
            ),
          ),
          // VideoPlayer(widget.betterPlayerController!),
        ),
        Positioned.fill(
          bottom: 0.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _videoPlayerHelper.toggleVideo(widget.betterPlayerController);
            },
            child: Container(
              height: widget.constraints.maxHeight,
              width: widget.constraints.maxWidth,
            ),
          ),
        ),
      ],
    );
  }
}
