import 'package:better_player/better_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/components/video_meta_data.dart';

class CarouselVideoPlayer extends StatefulWidget {
  const CarouselVideoPlayer({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  _CarouselVideoPlayerState createState() => _CarouselVideoPlayerState();
}

class _CarouselVideoPlayerState extends State<CarouselVideoPlayer> {
  // late BetterPlayerController _betterPlayerController;
  // late BetterPlayerDataSource _betterPlayerDataSource;
  Superuser? _superuser;
  Duration? _duration = Duration(seconds: 0);
  Duration? _position = Duration(seconds: 0);

  // @override
  // void initState() {
  //   BetterPlayerConfiguration betterPlayerConfiguration =
  //       BetterPlayerConfiguration(
  //     aspectRatio: 16 / 9,
  //     fit: BoxFit.contain,
  //     autoPlay: true,
  //   );
  //   _betterPlayerDataSource = BetterPlayerDataSource(
  //     BetterPlayerDataSourceType.network,
  //     'https://stream.mux.com/' + widget.video.playbackIds[0] + '.m3u8',
  //     cacheConfiguration: BetterPlayerCacheConfiguration(
  //       useCache: true,
  //       preCacheSize: 10 * 1024 * 1024,
  //       maxCacheSize: 10 * 1024 * 1024,
  //       maxCacheFileSize: 10 * 1024 * 1024,

  //       ///Android only option to use cached video between app sessions
  //       key: "testCacheKey",
  //     ),
  //   );
  //   _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
  //   super.initState();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Cache"),
  //     ),
  //     body: Column(
  //       children: [
  //         const SizedBox(height: 8),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16),
  //           child: Text(
  //             "Player with cache enabled. To test this feature, first plays "
  //             "video, then leave this page, turn internet off and enter "
  //             "page again. You should be able to play video without "
  //             "internet connection.",
  //             style: TextStyle(fontSize: 16),
  //           ),
  //         ),
  //         AspectRatio(
  //           aspectRatio: 16 / 9,
  //           child: BetterPlayer(controller: _betterPlayerController),
  //         ),
  //         TextButton(
  //           child: Text("Start pre cache"),
  //           onPressed: () {
  //             _betterPlayerController.preCache(_betterPlayerDataSource);
  //           },
  //         ),
  //         TextButton(
  //           child: Text("Stop pre cache"),
  //           onPressed: () {
  //             _betterPlayerController.stopPreCache(_betterPlayerDataSource);
  //           },
  //         ),
  //         TextButton(
  //           child: Text("Play video"),
  //           onPressed: () {
  //             _betterPlayerController.setupDataSource(_betterPlayerDataSource);
  //           },
  //         ),
  //         TextButton(
  //           child: Text("Clear cache"),
  //           onPressed: () {
  //             _betterPlayerController.clearCache();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  late BetterPlayerController _betterPlayerController;

  void _initializeVideo() async {
    // Size size = MediaQuery.of(context).size;

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      'https://stream.mux.com/' + widget.video.playbackIds[0] + '.m3u8',
      subtitles: [],
      cacheConfiguration: BetterPlayerCacheConfiguration(
          // useCache: true,
          // preCacheSize: 10 * 1024 * 1024,
          // maxCacheSize: 10 * 1024 * 1024,
          // maxCacheFileSize: 10 * 1024 * 1024,

          // ///Android only option to use cached video between app sessions
          // key: "testCacheKey",
          ),
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
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

    _betterPlayerController.videoPlayerController?.addListener(() {
      if (mounted) {
        setState(() {
          _position =
              _betterPlayerController.videoPlayerController?.value.position;
          _duration =
              _betterPlayerController.videoPlayerController?.value.duration;
        });
      }
    });

    // _betterPlayerController.addEventsListener((event) {
    //   print("Better player event: ${event.betterPlayerEventType}");
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });

    // _videoPlayerListener = () {
    //   print('here');
    //   if (mounted) {
    //     setState(() {});
    //   }
    // };

    // if (_betterPlayerController.videoPlayerController != null) {
    //   _betterPlayerController.videoPlayerController!.addListener(
    //     _videoPlayerListener!,
    //   );
    // }

    // _betterPlayerController = BetterPlayerController.network(
    //     'https://stream.mux.com/' + widget.video.playbackIds[0] + '.m3u8')
    //   ..addListener(_videoPlayerListener!)
    //   ..setVolume(1.0)
    //   ..setLooping(true)
    //   ..initialize()
    //   ..play().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  Future _loadUserAndLog() async {
    _superuser = await SuperuserService().getSuperuserFromId(
      widget.video.superuserId,
    );
    _logWatchedEvent();
    if (mounted) {
      setState(() {});
    }
  }

  void _logWatchedEvent() {
    if (_superuser == null) {
      return;
    }

    final analytics = Provider.of<FirebaseAnalytics>(
      context,
      listen: false,
    );

    analytics.logEvent(
      name: 'vm_watched',
      parameters: <String, dynamic>{
        'video_id': widget.video.id,
        'watcher_id': _superuser!.id,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _loadUserAndLog();
  }

  @override
  void dispose() {
    super.dispose();
    // if (_betterPlayerController != null) {
    //   _betterPlayerController!.dispose();
    // }

    // _betterPlayerController = null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var aspectRatio = _betterPlayerController.getAspectRatio();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Transform.scale(
              scale: aspectRatio! / (size.width / (constraints.maxHeight)),
              child: Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: BetterPlayer(
                    controller: _betterPlayerController,
                  ),
                ),
              ),
            ),
            if (_superuser != null)
              VideoMetaData(
                video: widget.video,
                superuser: _superuser!,
                duration: _duration,
                position: _position,
              ),
          ],
        );
      },
    );
  }
}
