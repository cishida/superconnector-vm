import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/formatters/timestamp_formatter.dart';

class VideoTile extends StatefulWidget {
  const VideoTile({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  Superuser? _owner;

  Future _loadUser(Superuser superuser) async {
    if (widget.video.superuserId == superuser.id && mounted) {
      setState(() {
        _owner = superuser;
      });
    }
    if (widget.video.status != 'ready') {
      _owner =
          await SuperuserService().getSuperuserFromId(widget.video.superuserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    if (superuser == null) {
      return Container();
    }

    bool unwatched = widget.video.unwatchedIds.contains(superuser.id);

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      _loadUser(superuser);
    });

    return Container(
      height: 146.0,
      width: 110.0,
      // color: Colors.black,
      margin: const EdgeInsets.only(
        right: 1.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: widget.video.playbackIds.length > 0
                  ? Image(
                      fit: BoxFit.fitWidth,
                      image: CachedNetworkImageProvider(
                        'https://image.mux.com/' +
                            widget.video.playbackIds.first +
                            '/animated.gif?start=1&end=2',
                      ),
                    )
                  : (_owner != null
                      ?
                      // Stack(
                      //   children: [
                      //     Image(
                      //       fit: BoxFit.fitHeight,
                      //       image: CachedNetworkImageProvider(
                      //         _owner!.photoUrl,
                      //       ),
                      //     ),
                      //     VideoTileLinearProgress(),
                      //   ],
                      // )
                      Stack(
                          children: [
                            Positioned(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Image.asset(
                                  'assets/images/authenticated/vm-connection-gradient.png',
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.black.withOpacity(.5),
                            ),
                            Center(
                              child: VideoTileLinearProgress(),
                            )
                          ],
                        )
                      : VideoTileLinearProgress()),
            ),
          ),
          if (unwatched)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  color: Colors.black.withOpacity(.6),
                  child: Center(
                    child: Icon(
                      Icons.circle,
                      size: 15.0,
                      color: ConstantColors.PRIMARY,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 3.0,
            left: 8.0,
            child: Text(
              TimestampFormatter().getChatTileTime(
                Timestamp.fromDate(
                  widget.video.created,
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoTileLinearProgress extends StatefulWidget {
  const VideoTileLinearProgress({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoTileLinearProgress> createState() =>
      _VideoTileLinearProgressState();
}

class _VideoTileLinearProgressState extends State<VideoTileLinearProgress> {
  @override
  Widget build(BuildContext context) {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

    cameraHandler.addListener(() {
      print(cameraHandler.progress.toDouble() -
          (cameraHandler.progress > 25 ? .15 : 0) / 100);
      if (mounted) setState(() {});
    });

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: LinearProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(
            ConstantColors.PRIMARY,
          ),
          value: (cameraHandler.progress.toDouble() -
                  (cameraHandler.progress > 25 ? 5 : 0)) /
              100,
        ),
      ),
    );
  }
}
