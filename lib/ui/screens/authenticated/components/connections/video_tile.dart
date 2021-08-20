import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

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
  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

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
                            '/animated.gif',
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
          if (superuser != null &&
              !widget.video.viewerIds.contains(superuser.id))
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
          // Positioned(
          //   bottom: 0.0,
          //   child: Text(
          //     TimestampFormatter().getChatTileTime(
          //       Timestamp.fromDate(
          //         widget.video.created,
          //       ),
          //     ),
          //     style: TextStyle(
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
