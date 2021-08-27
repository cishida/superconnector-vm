import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class OnboardingNotifications extends StatelessWidget {
  const OnboardingNotifications({
    Key? key,
    required this.onSkip,
  }) : super(key: key);

  final Function onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onSkip(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 26.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: ConstantColors.PRIMARY,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, left: 10.0),
                  child: Image.asset(
                    'assets/images/authenticated/onboarding/right-arrow-icon.png',
                    width: 18.0,
                    height: 13.0,
                  ),
                ),
              ],
            ),
          ),
        ),
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
