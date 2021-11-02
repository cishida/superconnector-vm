import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/camera_lens_container/camera_lens_container.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_icon.dart';
import 'package:superconnector_vm/core/utils/extensions/string_extension.dart';

class CameraMenu extends StatelessWidget {
  const CameraMenu({
    Key? key,
    required this.toggleCamera,
  }) : super(key: key);

  final Function toggleCamera;

  List<Widget> _buildIcons(
    BuildContext context,
  ) {
    Map<String, double> nameSizes = {
      'flip': 20.0,
      'flash': 15.0,
      'upload': 16.0,
      'lenses': 22.0,
      'message': 28.0,
      'trending': 22.0,
      'intro': 20.4,
      'contract': 22.0,
      'invoice': 19.0,
      'pay': 13.0,
    };

    List<Widget> widgets = [];

    nameSizes.forEach((key, value) {
      widgets.add(
        CameraIcon(
          imageName: 'assets/images/authenticated/record/camera-menu-' +
              key.toLowerCase() +
              '.png',
          title: key.capitalize(),
          onPress: () {
            switch (key) {
              case 'Flip':
                toggleCamera();
                break;
              case 'Flash':
                print('toggle flash');
                break;
              default:
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => CameraLensContainer(
                      lens: key,
                    ),
                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(
                      opacity: anim,
                      child: child,
                    ),
                    transitionDuration: Duration(
                      milliseconds: 200,
                    ),
                  ),
                );
            }
          },
          width: value,
        ),
      );
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    CameraHandler cameraHandler = Provider.of<CameraHandler>(context);

    return Positioned.fill(
      top: 51.0,
      right: 0.0,
      child: Align(
        alignment: Alignment.topRight,
        child: AnimatedOpacity(
          opacity: !cameraHandler.isRecording() ? 1.0 : 0.0,
          duration: const Duration(
            milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildIcons(
              context,
            ),
          ),
        ),
      ),
    );
  }
}
