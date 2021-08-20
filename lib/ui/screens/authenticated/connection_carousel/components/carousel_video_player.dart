import 'package:better_player/better_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/utils/video/video_player_helper.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/components/custom_controls_widget.dart';
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
  Superuser? _videoSuperuser;
  Duration? _duration = Duration(seconds: 0);
  Duration? _position = Duration(seconds: 0);
  VideoPlayerHelper _videoPlayerHelper = VideoPlayerHelper();
  BetterPlayerTheme _playerTheme = BetterPlayerTheme.custom;
  late BetterPlayerController _betterPlayerController;

  void _initializeVideo() async {
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
        autoDispose: true,
        looping: true,
        aspectRatio: 9 / 16,
        fit: BoxFit.cover,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: true,
          playerTheme: _playerTheme,
          customControlsBuilder: (controller) => CustomControlsWidget(
            controller: controller,
          ),
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
  }

  Future _loadUserAndLog() async {
    _videoSuperuser = await SuperuserService().getSuperuserFromId(
      widget.video.superuserId,
    );
    _logWatchedEvent();
    if (mounted) {
      setState(() {});
    }
  }

  void _logWatchedEvent() {
    Superuser? currentSuperuser = Provider.of<Superuser?>(
      context,
      listen: false,
    );
    if (_videoSuperuser == null || currentSuperuser == null) {
      return;
    }

    if (!widget.video.viewerIds.contains(currentSuperuser.id)) {
      widget.video.viewerIds.add(currentSuperuser.id);
      widget.video.update();
    }

    final analytics = Provider.of<FirebaseAnalytics>(
      context,
      listen: false,
    );

    analytics.logEvent(
      name: 'vm_watched',
      parameters: <String, dynamic>{
        'video_id': widget.video.id,
        'watcher_id': currentSuperuser.id,
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
  }

  @override
  Widget build(BuildContext context) {
    var aspectRatio = _betterPlayerController.getAspectRatio();

    return Container(
      color: Colors.blue,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Transform.scale(
                scale: aspectRatio! /
                    (constraints.maxWidth / (constraints.maxHeight)),
                child: BetterPlayerMultipleGestureDetector(
                  onTap: () {
                    print('test');
                    _videoPlayerHelper.toggleVideo(_betterPlayerController);
                  },
                  child: BetterPlayer(
                    controller: _betterPlayerController,
                  ),
                ),
              );
            },
          ),
          if (_videoSuperuser != null)
            VideoMetaData(
              video: widget.video,
              superuser: _videoSuperuser!,
              duration: _duration,
              position: _position,
            ),
        ],
      ),
    );
  }
}
