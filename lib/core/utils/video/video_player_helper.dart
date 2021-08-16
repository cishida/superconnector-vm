import 'package:better_player/better_player.dart';

class VideoPlayerHelper {
  void toggleVideo(BetterPlayerController? betterPlayerController) {
    print('toggle');
    if (betterPlayerController == null) {
      return;
    }

    bool? isPlaying = betterPlayerController.isPlaying();

    if (isPlaying == null) {
      return;
    }

    isPlaying ? betterPlayerController.pause() : betterPlayerController.play();
  }
}
