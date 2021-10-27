import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/video_tile_overlay.dart';

class VideoGridTile extends StatefulWidget {
  const VideoGridTile({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  _VideoGridTileState createState() => _VideoGridTileState();
}

class _VideoGridTileState extends State<VideoGridTile> {
  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        // borderRadius: BorderRadius.circular(3.0),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(3.0),
              child: widget.video.playbackIds.length > 0
                  ? Image(
                      fit: BoxFit.fitWidth,
                      image: CachedNetworkImageProvider(
                        'https://image.mux.com/' +
                            widget.video.playbackIds.first +
                            ConstantStrings.GIF_ARGS,
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
          if (superuser != null &&
              widget.video.unwatchedIds.contains(superuser.id))
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
          //   left: 8.0,
          //   bottom: 3.0,
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
          VideoTileOverlay(
            video: widget.video,
          ),
        ],
      ),
    );
  }
}
