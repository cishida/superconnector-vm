import 'package:flutter/material.dart';
import 'package:superconnector_vm/ui/components/overlay_text_form_field.dart';

class OverlayInput extends StatefulWidget {
  OverlayInput({
    Key? key,
    required this.fieldName,
    required this.exampleText,
    required this.onSubmit,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
    this.textInputAction = TextInputAction.send,
    this.value = '',
  }) : super(key: key);

  final String fieldName;
  final String exampleText;
  final Function onSubmit;
  final TextCapitalization textCapitalization;
  final Function? onChanged;
  final TextInputAction textInputAction;
  final String value;

  @override
  _OverlayInputState createState() => _OverlayInputState();
}

class _OverlayInputState extends State<OverlayInput> {
  final _formKey = GlobalKey<FormState>();

  // _onChanged(text) {
  //   print(text);
  // }

  _validate(text) {
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) => Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: OverlayTextFormField(
                          fieldKey: widget.fieldName,
                          value: widget.value,
                          autofocus: true,
                          cursorColor: Colors.white,
                          focusedBorderColor: Colors.white,
                          textColor: Colors.white,
                          textCapitalization: widget.textCapitalization,
                          onComplete: () {
                            final form = _formKey.currentState;
                            if (form != null) {
                              form.save();
                            }
                          },
                          onSaved: (String? text) {
                            widget.onSubmit(text);
                            Navigator.pop(context);
                          },
                          validate: (String? text) => _validate(text),
                          onChanged: (String? text) {
                            if (widget.onChanged != null) {
                              widget.onChanged!(text);
                            }
                          },
                          textInputAction: widget.textInputAction,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25.0,
                      ),
                      child: Text(
                        widget.exampleText,
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
      ),
    );
  }
}
