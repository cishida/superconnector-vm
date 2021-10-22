import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/ui/components/overlays/overlay_text_form_field.dart';

class CaptionOverlay extends StatefulWidget {
  const CaptionOverlay({
    Key? key,
  }) : super(key: key);

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
