import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_icon.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/caption_overlay.dart';

class CameraOptions extends StatelessWidget {
  const CameraOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

    return Positioned(
      top: 71.0,
      right: 0.0,
      child: AnimatedOpacity(
        opacity: cameraHandler.cameraController == null ||
                cameraHandler.cameraController!.value.isRecordingVideo
            ? 0.0
            : 1.0,
        duration: const Duration(
          milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
        ),
        child: Column(
          children: [
            CameraIcon(
              title: 'Filters',
              imageName:
                  'assets/images/authenticated/record/camera-filter-icon.png',
              onPress: () {
                cameraHandler.browsingFilters = !cameraHandler.browsingFilters;
              },
            ),
            CameraIcon(
              title: 'Caption',
              imageName:
                  'assets/images/authenticated/record/camera-caption-icon.png',
              onPress: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return CaptionOverlay();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
