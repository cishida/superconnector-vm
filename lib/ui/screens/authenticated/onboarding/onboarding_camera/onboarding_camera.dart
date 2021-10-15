import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/bar_button.dart';

class OnboardingCamera extends StatelessWidget {
  const OnboardingCamera({
    Key? key,
    required this.nextPage,
  }) : super(key: key);

  final Function nextPage;

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
                'Camera Access',
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
                'This lets you use your phone’s camera to record and share videos. ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                width: size.width,
                child: BarButton(
                  textColor: ConstantColors.PRIMARY,
                  backgroundColor: Colors.white,
                  title: 'Allow Camera Access',
                  onPressed: () async {
                    Map<Permission, PermissionStatus> statuses = await [
                      Permission.camera,
                      Permission.microphone,
                    ].request();

                    if (statuses.values.first.isDenied ||
                        statuses.values.first.isPermanentlyDenied) {
                      AppSettings.openAppSettings();
                    }

                    nextPage();
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 0.0,
          child: GestureDetector(
            onTap: () => nextPage(),
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
