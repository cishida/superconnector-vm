import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/providers/camera_provider.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class MediaTileProgress extends StatefulWidget {
  const MediaTileProgress({
    Key? key,
  }) : super(key: key);

  @override
  State<MediaTileProgress> createState() => _MediaTileProgressState();
}

class _MediaTileProgressState extends State<MediaTileProgress> {
  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(
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
          value: cameraProvider.progress / 100,
        ),
      ),
    );
  }
}
