import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/photo/photo.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/media_tile_overlay.dart';

class MediaGridTile extends StatefulWidget {
  const MediaGridTile({
    Key? key,
    this.video,
    this.photo,
  }) : super(key: key);

  final Video? video;
  final Photo? photo;

  @override
  _MediaGridTileState createState() => _MediaGridTileState();
}

class _MediaGridTileState extends State<MediaGridTile> {
  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    if (superuser == null) {
      return Container();
    }

    dynamic media;
    String url = '';

    if (widget.video != null) {
      media = widget.video;
      url = media.playbackIds.length > 0
          ? 'https://image.mux.com/' +
              media.playbackIds.first +
              ConstantStrings.GIF_ARGS
          : '';
    } else {
      media = widget.photo;
      url = media.url;
    }

    bool unwatched = media.unwatchedIds.contains(superuser.id);

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
              child: url.isNotEmpty
                  ? Image(
                      fit: BoxFit.fitWidth,
                      image: CachedNetworkImageProvider(
                        url,
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
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
          MediaTileOverlay(
            created: media.created,
            caption: media.caption,
          ),
        ],
      ),
    );
  }
}
