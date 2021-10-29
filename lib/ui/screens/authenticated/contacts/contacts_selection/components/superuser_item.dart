import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';

class SuperuserItem extends StatelessWidget {
  const SuperuserItem({
    Key? key,
    required this.superuser,
    this.tag = '',
    required this.isSelectable,
    this.isSelected = false,
  }) : super(key: key);

  final Superuser superuser;
  final String? tag;
  final bool isSelectable;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final currentSuperuser = Provider.of<Superuser?>(
      context,
    );

    if (currentSuperuser == null) {
      return Container();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 7.0,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 19.0,
                  right: 12.0,
                ),
                child: SuperuserImage(
                  url: superuser.photoUrl,
                  radius: 19.0,
                  bordered: false,
                  reversed: true,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    superuser.id == ConstantStrings.SUPERCONNECTOR_ID
                        ? currentSuperuser.fullName
                        : superuser.fullName,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: ConstantColors.navItemTitle,
                    ),
                  ),
                  Text(
                    'Connected',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: ConstantColors.navItemSub,
                    ),
                  ),
                ],
              ),
              Spacer(),
              if (isSelectable)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 22.0,
                  ),
                  child: superuser.id == currentSuperuser.id
                      ? Image.asset(
                          'assets/images/authenticated/contacts-check-mark.png',
                          width: 24.0,
                          height: 24.0,
                          color: Colors.grey.withOpacity(.4),
                        )
                      : (isSelected
                          ? Image.asset(
                              'assets/images/authenticated/contacts-check-mark.png',
                              width: 24.0,
                              height: 24.0,
                              color: ConstantColors.PRIMARY,
                            )
                          : Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ConstantColors
                                      .CONTACT_SELECTION_CIRCLE_BORDER,
                                ),
                              ),
                            )),
                ),
            ],
          ),
        ),
        // Underline(
        //   margin: const EdgeInsets.only(left: 69.0),
        // ),
        // Container(
        //   height: 1.0,
        //   // width: MediaQuery.of(context).size.width,
        //   color: ConstantColors.CONTACTS_GROUP_BACKGROUND,
        //   margin: const EdgeInsets.only(
        //     left: 69.0,
        //   ),
        // ),
      ],
    );
  }
}
