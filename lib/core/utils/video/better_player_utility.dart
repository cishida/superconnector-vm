import 'package:better_player/better_player.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class BetterPlayerUtility {
  static double getVideoDuration(
      BetterPlayerController? betterPlayerController) {
    if (betterPlayerController == null) {
      return 0.0;
    }

    double? duration = (betterPlayerController
        .videoPlayerController?.value.duration!.inMilliseconds
        .toDouble());
    if (duration != null) {
      return double.parse((duration / 1000).toStringAsFixed(2));
    } else {
      return 0.0;
    }
  }

  static BetterPlayerController initializeFromVideoFile({
    required XFile videoFile,
    required Function onEvent,
  }) {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      videoFile.path,
      subtitles: [],
    );

    BetterPlayerController betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        startAt: Duration(milliseconds: 50),
        autoPlay: true,
        looping: true,
        aspectRatio: 9 / 16,
        fit: BoxFit.cover,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
        placeholder: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    betterPlayerController.addEventsListener((event) {
      onEvent();
    });

    betterPlayerController.videoPlayerController?.addListener(() {
      onEvent();
    });

    return betterPlayerController;
  }
}
