import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';

class SupercontactItem extends StatefulWidget {
  const SupercontactItem({
    Key? key,
    required this.supercontact,
    this.isSelected = false,
  }) : super(key: key);

  final Supercontact supercontact;
  final bool isSelected;

  @override
  _SupercontactItemState createState() => _SupercontactItemState();
}

class _SupercontactItemState extends State<SupercontactItem> {
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
                child: SuperuserImage(
                  url: widget.supercontact.photoUrl,
                  radius: 19.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.supercontact.fullName,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '@' + widget.supercontact.username,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  right: 22.0,
                ),
                child: widget.isSelected
                    ? Image.asset(
                        'assets/images/authenticated/contacts-check-mark.png',
                        width: 24.0,
                        height: 24.0,
                      )
                    : Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                ConstantColors.CONTACT_SELECTION_CIRCLE_BORDER,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          // width: MediaQuery.of(context).size.width,
          color: ConstantColors.DIVIDER_GRAY,
          margin: const EdgeInsets.only(
            left: 69.0,
          ),
        ),
      ],
    );
  }
}
