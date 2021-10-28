import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/images/empty_image.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({
    Key? key,
    required this.contact,
    required this.isSelectable,
    this.isSelected = false,
  }) : super(key: key);

  final Contact contact;
  final bool isSelectable;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
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
                child: contact.avatar != null
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(contact.avatar!),
                        radius: 19.0,
                      )
                    : EmptyImage(
                        size: 38.0,
                        isReversed: true,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.displayName!,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: ConstantColors.navItemTitle,
                    ),
                  ),
                  Text(
                    contact.phones!.first.value!,
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
                  child: isSelected
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
                        ),
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
