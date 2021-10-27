import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/core/utils/formatters/timestamp_formatter.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/video_tile_overlay.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/video_tile_progress.dart';

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
        color: Colors.grey.shade400,
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
                            ConstantStrings.GIF_ARGS,
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
                      //     VideoTileProgress(),
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
                              child: VideoTileProgress(),
                            )
                          ],
                        )
                      : VideoTileProgress()),
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
          VideoTileOverlay(
            video: widget.video,
          ),
        ],
      ),
    );
  }
}
