import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/providers/camera_provider.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_transform.dart';
import 'package:superconnector_vm/core/utils/extensions/string_extension.dart';

class CameraLensContainer extends StatefulWidget {
  const CameraLensContainer({
    Key? key,
    required this.lens,
    this.child,
    this.reset,
  }) : super(key: key);

  final String lens;
  final Widget? child;
  final Function? reset;

  @override
  _CameraLensContainerState createState() => _CameraLensContainerState();
}

class _CameraLensContainerState extends State<CameraLensContainer> {
  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);
    final cameraProvider = Provider.of<CameraProvider>(
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
                    cameraProvider.cameraController!,
                  ),
                ),
                Center(
                  child: Text(
                    widget.lens.capitalize() + ' Lens',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                if (widget.child != null) widget.child!,
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
              height: cameraProvider.browsingFilters
                  ? ConstantValues.BROWSE_FILTER_HEIGHT
                  : ConstantValues.BOTTOM_NAV_HEIGHT,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (widget.reset != null) {
                    widget.reset!();
                  }
                  var selectedContacts = Provider.of<SelectedContacts>(
                    context,
                    listen: false,
                  );
                  selectedContacts.reset();
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/authenticated/record/camera-cancel-lens.png',
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
