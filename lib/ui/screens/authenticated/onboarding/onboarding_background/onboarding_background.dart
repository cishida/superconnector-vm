import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/components/profile_image_picker.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/onboarding_background/components/background_form_field.dart';

class OnboardingBackground extends StatefulWidget {
  const OnboardingBackground({
    Key? key,
    required this.formKey,
    this.attemptedSubmission = false,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final bool attemptedSubmission;

  @override
  _OnboardingBackgroundState createState() => _OnboardingBackgroundState();
}

class _OnboardingBackgroundState extends State<OnboardingBackground> {
  final _fieldMap = {
    'fullName': 'Full Name',
    'username': 'Username',
  };

  List<Widget> _buildForm() {
    List<Widget> backgroundWidgets = [];

    _fieldMap.forEach((key, value) {
      backgroundWidgets.add(
        BackgroundFormField(
          fieldKey: key,
          value: value,
          needsValidation: true,
        ),
      );
    });

    return backgroundWidgets;
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Container();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 148.0,
          left: 0.0,
          child: Image.asset(
            'assets/images/authenticated/onboarding/left-leaves.png',
            width: 67.0,
          ),
        ),
        Positioned(
          top: 59.0,
          right: 0.0,
          child: Image.asset(
            'assets/images/authenticated/onboarding/right-leaves.png',
            width: 44.0,
          ),
        ),
        Positioned(
          top: -40.0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/authenticated/onboarding/hanging-lamps.png',
              width: 123.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.0),
          child: Column(
            children: [
              SizedBox(
                height: 146.0,
              ),
              ProfileImagePicker(
                superuser: superuser,
                width: 100.0,
              ),
              Builder(
                builder: (context) => Form(
                  key: widget.formKey,
                  autovalidateMode: widget.attemptedSubmission
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: _buildForm(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
