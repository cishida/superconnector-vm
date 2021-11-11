import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class LandingTextField extends StatelessWidget {
  const LandingTextField({
    Key? key,
    required this.textController,
    required this.focusNode,
    this.onChanged,
    this.enabled = false,
  }) : super(key: key);

  final TextEditingController textController;
  final FocusNode focusNode;
  final Function(String)? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );

    TextStyle textFieldStyle = TextStyle(
      color: Colors.white.withOpacity(.4),
      fontWeight: FontWeight.w600,
      fontSize: 17.0,
      // backgroundColor: ConstantColors.SECONDARY,
    );

    return Stack(
      children: [
        TextField(
          focusNode: focusNode,
          autofocus: false,
          autocorrect: false,
          enabled: enabled,
          style: textFieldStyle.copyWith(color: Colors.white),
          cursorColor: ConstantColors.PRIMARY,
          keyboardAppearance: Brightness.light,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            MaskedInputFormatter('(###)###-####'),
          ],
          decoration: InputDecoration(
            labelText: 'Mobile Number *',
            labelStyle: textFieldStyle,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(
              68.0,
              14.0,
              5.0,
              13.0,
            ),
            disabledBorder: border,
            enabledBorder: border,
            border: border,
            focusedBorder: border,
            filled: true,
            fillColor: Colors.white.withOpacity(.2),
          ),
          controller: textController,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onChanged: (text) {
            if (onChanged != null) {
              onChanged!(text);
            }
          },
        ),
        Positioned(
          left: 21.0,
          top: 15,
          child: Text(
            '+1',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: 55.0,
          top: 11.0,
          bottom: 11.0,
          child: Container(
            width: 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.0),
              color: Colors.black.withOpacity(.2),
            ),
          ),
        ),
      ],
    );
  }
}
