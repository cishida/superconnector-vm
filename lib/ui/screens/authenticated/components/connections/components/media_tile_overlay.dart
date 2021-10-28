import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/formatters/timestamp_formatter.dart';

class MediaTileOverlay extends StatelessWidget {
  const MediaTileOverlay({
    Key? key,
    // required this.video,
    required this.created,
    this.caption = '',
  }) : super(key: key);

  // final Video video;
  final DateTime created;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 4.0,
      left: 8.0,
      right: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              TimestampFormatter().getChatTileTime(
                Timestamp.fromDate(
                  created,
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (caption.isNotEmpty)
            Expanded(
              child: Container(
                height: 24,
                padding: const EdgeInsets.only(left: 2.0),
                color: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    caption.replaceAll('', '\u200B'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
