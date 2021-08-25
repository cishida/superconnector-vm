import 'package:flutter/material.dart';

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 19.0,
            right: 44.0,
            top: 49.0,
            bottom: 0.0,
          ),
          child: Image.asset(
            'assets/images/authenticated/onboarding-welcome.png',
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
