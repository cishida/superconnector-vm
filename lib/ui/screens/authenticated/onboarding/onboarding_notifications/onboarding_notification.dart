import 'package:flutter/material.dart';

class OnboardingNotifications extends StatelessWidget {
  const OnboardingNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 0.0,
            right: 0.0,
            top: 100.0,
            bottom: 47.0,
          ),
          child: Image.asset(
            'assets/images/authenticated/onboarding-women-meeting.png',
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
