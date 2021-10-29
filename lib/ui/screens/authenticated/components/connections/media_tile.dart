import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/photo/photo.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/media_tile_overlay.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/media_tile_progress.dart';

class MediaTile extends StatefulWidget {
  const MediaTile({
    Key? key,
    this.video,
    this.photo,
  }) : super(key: key);

  final Video? video;
  final Photo? photo;

  @override
  _MediaTileState createState() => _MediaTileState();
}

class _MediaTileState extends State<MediaTile> {
  Superuser? _owner;

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
      height: 146.0,
      width: 110.0,
      // color: Colors.black,
      margin: const EdgeInsets.only(
        right: 1.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: url.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: url,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            // colorFilter: ColorFilter.mode(
                            //   Colors.red,
                            //   BlendMode.colorBurn,
                            // ),
                          ),
                        ),
                      ),
                      // placeholder: (context, url) =>
                      //     CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  // Image(
                  //     fit: BoxFit.fitWidth,
                  //     image: CachedNetworkImageProvider(
                  //       url,
                  //     ),
                  //   )
                  : Stack(
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
                          child: MediaTileProgress(),
                        )
                      ],
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
          MediaTileOverlay(
            created: media.created,
            caption: media.caption,
          ),
        ],
      ),
    );
  }
}
