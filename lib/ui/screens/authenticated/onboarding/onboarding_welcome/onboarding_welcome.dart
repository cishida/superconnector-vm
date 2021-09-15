import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/bar_button.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/components/profile_image_picker.dart';

class OnboardingWelcome extends StatefulWidget {
  const OnboardingWelcome({
    Key? key,
    required this.nextPage,
  }) : super(key: key);

  final Function nextPage;

  @override
  _OnboardingWelcomeState createState() => _OnboardingWelcomeState();
}

class _OnboardingWelcomeState extends State<OnboardingWelcome> {
  // final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showError = false;

  String? _getPlaceholder(Superuser superuser) {
    return superuser.fullName != ''
        ? superuser.fullName
        : superuser.displayName;
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Container();
    }

    final Size size = MediaQuery.of(context).size;
    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );

    TextStyle textFieldStyle = TextStyle(
      color: Colors.black.withOpacity(.4),
      fontWeight: FontWeight.w600,
      fontSize: 17.0,
      // backgroundColor: ConstantColors.SECONDARY,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _focusNode.unfocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              'Superconnector is a video sharing app for your family. Enter your information to get started.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 28.0,
            ),
            Text(
              'FULL NAME',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: .2,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Stack(
              children: [
                TextFormField(
                  focusNode: _focusNode,
                  autofocus: false,
                  autocorrect: false,
                  style: textFieldStyle.copyWith(
                    color: Colors.black.withOpacity(.7),
                  ),
                  cursorColor: ConstantColors.PRIMARY,
                  keyboardAppearance: Brightness.light,
                  initialValue: _getPlaceholder(
                    superuser,
                  ),
                  decoration: InputDecoration(
                    labelText:
                        _showError ? 'Please add your name *' : 'Full name',
                    labelStyle: _showError
                        ? textFieldStyle.copyWith(
                            color: ConstantColors.PRIMARY,
                          )
                        : textFieldStyle,
                    errorStyle: TextStyle(
                      color: Colors.white,
                      height: 0,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(
                      21.0,
                      14.0,
                      5.0,
                      13.0,
                    ),
                    enabledBorder: border,
                    focusedBorder: border,
                    errorBorder: border,
                    focusedErrorBorder: border,
                    filled: true,
                    fillColor: Colors.white.withOpacity(.7),
                  ),
                  // controller: _textController,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    superuser.fullName = value;
                    setState(() {
                      _showError = false;
                    });
                  },
                ),
              ],
            ),
            ProfileImagePicker(
              superuser: superuser,
              width: 100.0,
            ),
            Spacer(),
            Container(
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 65.0,
                ),
                child: BarButton(
                  textColor: ConstantColors.PRIMARY,
                  backgroundColor: Colors.white,
                  title: 'Continue',
                  onPressed: () {
                    if (superuser.fullName.isEmpty) {
                      setState(() {
                        _showError = true;
                      });
                    } else {
                      setState(() {
                        _showError = false;
                      });

                      widget.nextPage();
                    }
                    print(superuser.fullName);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
