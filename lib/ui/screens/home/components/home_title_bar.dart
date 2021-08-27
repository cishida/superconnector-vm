import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/account.dart';

class HomeTitleBar extends StatelessWidget {
  const HomeTitleBar({
    Key? key,
    required this.superuser,
  }) : super(key: key);

  final Superuser superuser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                'Family',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.5,
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // _panelController.open();
                SuperNavigator.handleContactsNavigation(
                  context: context,
                  shouldShowHistory: true,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 22.0),
                child: Image.asset(
                  'assets/images/authenticated/search-icon.png',
                  width: 26.0,
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                SuperNavigator.push(
                  context: context,
                  widget: Account(),
                  fullScreen: false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 9.0),
                child: SuperuserImage(
                  url: superuser.photoUrl,
                  radius: 21.0,
                  bordered: false,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 1.0,
          margin: const EdgeInsets.only(
            top: 9.0,
          ),
          color: ConstantColors.ED_GRAY,
        ),
      ],
    );
  }
}
