import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/caption_overlay.dart';

class SendBottomNav extends StatelessWidget {
  const SendBottomNav({
    Key? key,
    required this.browseFilters,
    required this.sendButton,
  }) : super(key: key);

  // final CameraHandler cameraHandler;
  final Widget browseFilters;
  final Widget sendButton;

  @override
  Widget build(BuildContext context) {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

    return BottomAppBar(
      color: ConstantColors.DARK_BLUE,
      child: AnimatedSize(
        duration: Duration(
          milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
        ),
        child: Container(
          alignment: Alignment.centerRight,
          height: cameraHandler.browsingFilters
              ? ConstantValues.BROWSE_FILTER_HEIGHT
              : ConstantValues.BOTTOM_NAV_HEIGHT,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return CaptionOverlay();
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Image.asset(
                    'assets/images/authenticated/record/camera-caption-icon.png',
                    width: 20,
                  ),
                ),
              ),
              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   onTap: () {
              //     SuperNavigator.handleContactsNavigation(
              //       context: context,
              //       confirm: () {
              //         Navigator.of(context).pop();
              //       },
              //     );
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 20.0),
              //     child: Image.asset(
              //       'assets/images/authenticated/record/camera-search-icon.png',
              //       width: 24,
              //     ),
              //   ),
              // ),
              Spacer(),
              cameraHandler.browsingFilters ? browseFilters : sendButton,
            ],
          ),
        ),
      ),
    );
  }
}
