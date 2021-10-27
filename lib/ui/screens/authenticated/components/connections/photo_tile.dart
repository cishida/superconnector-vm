import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/photo/photo.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/video_tile_progress.dart';

class PhotoTile extends StatefulWidget {
  const PhotoTile({
    Key? key,
    required this.photo,
  }) : super(key: key);

  final Photo photo;

  @override
  _PhotoTileState createState() => _PhotoTileState();
}

class _PhotoTileState extends State<PhotoTile> {
  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    if (superuser == null) {
      return Container();
    }

    bool unwatched = widget.photo.unwatchedIds.contains(superuser.id);

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
              child: widget.photo.url.length > 0
                  ? Image(
                      fit: BoxFit.fitWidth,
                      image: CachedNetworkImageProvider(
                        widget.photo.url,
                      ),
                    )
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
                          child: VideoTileProgress(),
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
          // PhotoTileOverlay(
          //   video: widget.video,
          // ),
        ],
      ),
    );
  }
}
