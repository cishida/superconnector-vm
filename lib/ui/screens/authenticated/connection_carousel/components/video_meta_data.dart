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
    this.superuser,
    this.duration,
    this.position,
    this.caption,
  }) : super(key: key);

  final DateTime created;
  final Superuser? superuser;
  final Duration? duration;
  final Duration? position;
  final String? caption;

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
    final Size size = MediaQuery.of(context).size;

    final selectedCaption = caption ?? cameraHandler.caption;

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
            if (position != null && duration != null)
              VideoTime(
                duration: duration!,
                position: position!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (superuser != null)
              Text(
                superuser!.fullName,
                style: textStyle,
              ),
            // if (caption != '')
            //   Container(
            //     child: Row(
            //       children: <Widget>[
            //         Flexible(child: Text("A looooooooooooooooooong text"))
            //       ],
            //     ),
            //   ),
            if (caption != '')
              Container(
                width: size.width / 2,
                child: Text(
                  '"' + selectedCaption + '"',
                  style: textStyle.copyWith(fontWeight: FontWeight.w600),
                ),
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
