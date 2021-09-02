import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class OverlayTextFormField extends StatelessWidget {
  OverlayTextFormField({
    Key? key,
    required this.fieldKey,
    required this.value,
    this.autofocus = false,
    this.textColor = ConstantColors.DARK_TEXT,
    this.cursorColor = ConstantColors.PRIMARY,
    this.focusedBorderColor = ConstantColors.PRIMARY,
    required this.onSaved,
    required this.onComplete,
    required this.validate,
    required this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.includeCharacterCount = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.borderColor = ConstantColors.GRAY_TEXT,
    this.labelColor,
  }) : super(key: key);

  final String fieldKey;
  final String value;
  final bool autofocus;
  final Color cursorColor;
  final Color textColor;
  final Color focusedBorderColor;
  final void Function(String?) onSaved;
  final Function onComplete;
  final String? Function(String?) validate;
  final void Function(String?) onChanged;
  final TextInputAction textInputAction;
  final bool includeCharacterCount;
  final TextCapitalization textCapitalization;
  final Color borderColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(30);

    OutlineInputBorder enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: borderColor,
      ),
    );

    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: focusedBorderColor,
      ),
    );

    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: ConstantColors.ERROR_RED,
      ),
    );

    return TextFormField(
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      // initialValue: value,
      textInputAction: textInputAction,
      keyboardAppearance: Brightness.dark,
      cursorColor: cursorColor,
      initialValue: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: 25,
          top: 20,
          bottom: 20,
          right: 25,
        ),
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: fieldKey,
        labelStyle: TextStyle(
          color: labelColor ?? textColor,
        ),
      ),
      style: TextStyle(
        color: textColor,
      ),
      onSaved: (text) => onSaved(text),
      onEditingComplete: () => onComplete(),
      validator: (text) => validate(text),
      onChanged: (text) => onChanged(text),
    );
  }
}
