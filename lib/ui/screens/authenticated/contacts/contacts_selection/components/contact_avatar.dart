import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    double radius = 19.0;

    if (contact.avatar != null && contact.avatar!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(
          contact.avatar!,
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).accentColor,
      child: Text(
        contact.initials(),
      ),
    );
  }
}
