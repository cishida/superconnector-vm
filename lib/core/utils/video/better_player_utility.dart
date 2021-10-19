import 'package:better_player/better_player.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;
import 'dart:ui' as ui;

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

  static Future<BetterPlayerController> initializeFromVideoFile({
    required Size size,
    required XFile videoFile,
    required Function onEvent,
  }) async {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      videoFile.path,
      subtitles: [],
    );

    final uint8list = await thumb.VideoThumbnail.thumbnailData(
      video: videoFile.path,
      // imageFormat: thumb.ImageFormat.JPEG,
      // maxWidth: size.width.toInt(),
      // maxHeight: size.height.toInt(),
      quality: 1,
    );

    BetterPlayerController betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        startAt: Duration(milliseconds: 50),
        autoPlay: true,
        showPlaceholderUntilPlay: false,
        looping: true,
        aspectRatio: 9 / 16,
        fit: BoxFit.cover,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
        // placeholder: uint8list != null
        //     ? Stack(
        //         children: [
        //           Image.memory(
        //             uint8list,
        //             // width: constraints.maxWidth,
        //             // height: constraints.maxHeight,
        //             fit: BoxFit.cover,
        //           ),
        //           BackdropFilter(
        //             filter: ui.ImageFilter.blur(
        //               sigmaX: 8.0,
        //               sigmaY: 8.0,
        //             ),
        //             child: Container(
        //               color: Colors.transparent,
        //             ),
        //           )
        //         ],
        //       )
        //     : Container(),
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
