import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class BackgroundFormField extends StatefulWidget {
  BackgroundFormField({
    Key? key,
    required this.fieldKey,
    required this.value,
    this.needsValidation = false,
  }) : super(key: key);

  final String fieldKey;
  final String value;
  final bool needsValidation;

  @override
  _BackgroundFormFieldState createState() => _BackgroundFormFieldState();
}

class _BackgroundFormFieldState extends State<BackgroundFormField> {
  SuperuserService _superuserService = SuperuserService();
  GlobalKey<FormFieldState> _textFormFieldKey = GlobalKey<FormFieldState>();

  bool _shouldValidate = false;
  bool _usernameUnique = true;
  bool _removePadding = false;
  bool _isLoadingUsername = false;

  checkUsername<bool>(String username) {
    setState(() {
      _isLoadingUsername = true;
    });
    _superuserService.isUsernameUnique(username).then((val) {
      if (mounted) {
        setState(() {
          _usernameUnique = val;
          // _removePadding = !val;
        });
      }

      _textFormFieldKey.currentState!.validate();

      if (val) {
        print("Username is unique");
      } else {
        print("UserName is taken");
      }
      setState(() {
        _isLoadingUsername = false;
      });
    });
    return _usernameUnique;
  }

  String? _getPlaceholder(String fieldKey, Superuser superuser) {
    String placeholder = '';

    if (widget.fieldKey == 'fullName') {
      placeholder =
          superuser.fullName != '' ? superuser.fullName : superuser.displayName;
    }

    // if (widget.fieldKey == 'username') {
    //   placeholder = superuser.displayName.replaceAll(' ', '').toLowerCase();
    //   placeholder = superuser.username != ''
    //       ? superuser.username
    //       : superuser.displayName.replaceAll(' ', '').toLowerCase();
    // }

    return placeholder;
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Container();
    }

    BorderRadius borderRadius = BorderRadius.circular(36);

    OutlineInputBorder enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: ConstantColors.PRIMARY,
      ),
    );

    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: ConstantColors.PRIMARY,
      ),
    );

    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        width: 2.0,
        color: ConstantColors.ERROR_RED,
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: _removePadding ? 8.0 : 20.0,
      ),
      child: Stack(
        children: [
          if (widget.fieldKey == 'username' && _isLoadingUsername)
            Positioned(
              right: 20.0,
              top: 25.0,
              height: 15.0,
              width: 15.0,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
              ),
            ),
          TextFormField(
            key: _textFormFieldKey,
            autocorrect: false,
            textCapitalization: widget.fieldKey == 'username'
                ? TextCapitalization.none
                : TextCapitalization.words,
            initialValue: _getPlaceholder(
              widget.fieldKey,
              superuser,
            ),
            keyboardAppearance: Brightness.dark,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 25,
                top: 23,
                bottom: 23,
              ),
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              border: OutlineInputBorder(
                borderRadius: borderRadius,
              ),
              labelText: widget.value,
              labelStyle: TextStyle(
                color: ConstantColors.PRIMARY,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
              errorStyle: TextStyle(
                color: ConstantColors.ERROR_RED,
                height: 0.6,
              ),
            ),
            onSaved: (value) {
              print('saving');
              if (value != null) {
                if (widget.fieldKey == 'username') {
                  superuser[widget.fieldKey] =
                      value.toLowerCase().replaceAll(' ', '');
                } else {
                  superuser[widget.fieldKey] = value;
                }
                superuser.update();
              }
            },
            onChanged: (value) {
              setState(() {
                _shouldValidate = true;
              });
              if (widget.fieldKey == 'username') {
                checkUsername(value.toLowerCase().replaceAll(' ', ''));
              }
            },
            validator: (text) {
              if (widget.fieldKey == 'website' ||
                  widget.fieldKey == 'location' ||
                  widget.fieldKey == 'workplace' ||
                  (!_shouldValidate && !widget.needsValidation)) {
                return null;
              }

              if (text == null || text.isEmpty) {
                setState(() {
                  _removePadding = true;
                });
                return "This is required.";
              }

              if (widget.fieldKey == 'username' && !_usernameUnique) {
                checkUsername(text.toLowerCase().replaceAll(' ', ''));
                setState(() {
                  _removePadding = true;
                });
                setState(() {
                  _removePadding = true;
                });
                return "Username already taken";
                // return null;
              }

              setState(() {
                _removePadding = false;
              });

              return null;
            },
          ),
        ],
      ),
    );
  }
}
