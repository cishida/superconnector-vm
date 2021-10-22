import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/ui/components/overlays/overlay_explanation.dart';
import 'package:superconnector_vm/ui/components/overlays/overlay_input.dart';
import 'package:superconnector_vm/ui/components/overlays/overlay_text_form_field.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_icon.dart';

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
      top: 65.0,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CameraIcon(
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
            ),
          ],
        ),
      ),
    );
  }
}

class CaptionOverlay extends StatefulWidget {
  const CaptionOverlay({Key? key}) : super(key: key);

  @override
  _CaptionOverlayState createState() => _CaptionOverlayState();
}

class _CaptionOverlayState extends State<CaptionOverlay> {
  final _formKey = GlobalKey<FormState>();
  final int _characterLimit = 160;

  @override
  Widget build(BuildContext context) {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black.withOpacity(0.7),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) => Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: OverlayTextFormField(
                        fieldKey: 'Caption',
                        value: cameraHandler.caption,
                        autofocus: true,
                        cursorColor: Colors.white,
                        focusedBorderColor: Colors.white,
                        textColor: Colors.white,
                        textCapitalization: TextCapitalization.sentences,
                        onComplete: () {
                          final form = _formKey.currentState;
                          if (form != null) {
                            form.save();
                          }
                        },
                        onSaved: (String? text) {
                          Navigator.pop(context);
                        },
                        validate: (String? text) {},
                        onChanged: (String? text) {
                          if (text == null) {
                            return;
                          }

                          cameraHandler.caption = text;
                        },
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 10.0),
                    child: Text(
                      cameraHandler.caption.length.toString() +
                          ' / $_characterLimit',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
