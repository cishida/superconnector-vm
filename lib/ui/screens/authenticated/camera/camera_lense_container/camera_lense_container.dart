import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_transform.dart';
import 'package:superconnector_vm/core/utils/extensions/string_extension.dart';

class CameraLenseContainer extends StatefulWidget {
  const CameraLenseContainer({
    Key? key,
    required this.lense,
  }) : super(key: key);

  final String lense;

  @override
  _CameraLenseContainerState createState() => _CameraLenseContainerState();
}

class _CameraLenseContainerState extends State<CameraLenseContainer> {
  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);
    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                CameraTransform(
                  constraints: constraints,
                  child: CameraPreview(
                    cameraHandler.cameraController!,
                  ),
                ),
                Center(
                  child: Text(
                    widget.lense.capitalize() + ' Lense',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: ConstantColors.DARK_BLUE,
          child: AnimatedSize(
            duration: Duration(
              milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
            ),
            child: Container(
              alignment: Alignment.center,
              height: cameraHandler.browsingFilters
                  ? ConstantValues.BROWSE_FILTER_HEIGHT
                  : ConstantValues.BOTTOM_NAV_HEIGHT,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/authenticated/record/camera-cancel-lense.png',
                    width: 28.0,
                    // color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
