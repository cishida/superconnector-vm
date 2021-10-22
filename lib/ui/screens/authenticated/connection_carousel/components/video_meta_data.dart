import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/core/utils/formatters/timestamp_formatter.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/components/video_time.dart';

class VideoMetaData extends StatelessWidget {
  const VideoMetaData({
    Key? key,
    required this.created,
    required this.superuser,
    required this.duration,
    required this.position,
    this.caption = '',
  }) : super(key: key);

  final DateTime created;
  final Superuser superuser;
  final Duration? duration;
  final Duration? position;
  final String caption;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 26 / 17,
    );

    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

    return Positioned(
      bottom: 20.0,
      left: 15.0,
      child: AnimatedOpacity(
        opacity: !cameraHandler.browsingFilters ? 1.0 : 0.0,
        duration: const Duration(
          milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VideoTime(
              duration: duration ?? Duration(seconds: 0),
              position: position ?? Duration(seconds: 0),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              superuser.fullName,
              style: textStyle,
            ),
            if (caption != '')
              Text(
                '"' + caption + '"',
                style: textStyle.copyWith(fontWeight: FontWeight.w600),
              ),
            // Text(
            //   '@' + superuser.username,
            //   style: textStyle,
            // ),
            Text(
              TimestampFormatter.getDateFromTimestamp(
                Timestamp.fromDate(
                  created,
                ),
              ),
              style: textStyle,
            ),
            Text(
              TimestampFormatter.getTimeFromTimestamp(
                Timestamp.fromDate(
                  created,
                ),
              ),
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
