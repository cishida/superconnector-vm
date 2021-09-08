import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/bar_button.dart';

class OnboardingNotifications extends StatelessWidget {
  const OnboardingNotifications({
    Key? key,
    required this.next,
  }) : super(key: key);

  final Function next;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
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
                'These tell you when you receive videos from family members so you can reply quickly.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Container(
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 65.0,
                  ),
                  child: BarButton(
                    textColor: ConstantColors.PRIMARY,
                    backgroundColor: Colors.white,
                    title: 'Turn On Notifications',
                    onPressed: () async {
                      await FirebaseMessaging.instance.requestPermission(
                        alert: true,
                        badge: true,
                        provisional: false,
                        sound: true,
                      );
                      next();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 0.0,
          child: GestureDetector(
            onTap: () => next(),
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
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, left: 10.0),
                    child: Image.asset(
                      'assets/images/authenticated/onboarding/right-arrow-icon.png',
                      color: Colors.white,
                      width: 18.0,
                      height: 13.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
