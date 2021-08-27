import 'package:flutter/material.dart';

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            // right: 9.0,
            // top: 49.0,
            // bottom: 0.0,
          ),
          child: Image.asset(
            'assets/images/authenticated/onboarding/onboarding-welcome.png',
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
