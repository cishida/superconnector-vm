import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class VideoTileProgress extends StatefulWidget {
  const VideoTileProgress({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoTileProgress> createState() => _VideoTileProgressState();
}

class _VideoTileProgressState extends State<VideoTileProgress> {
  @override
  Widget build(BuildContext context) {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

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
          value:
              (cameraHandler.progress - (cameraHandler.progress > 25 ? 5 : 0)) /
                  100,
        ),
      ),
    );
  }
}
