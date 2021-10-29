import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superconnector_vm/ui/components/permissions_template.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts.dart';

class ContactsPermission extends StatefulWidget {
  const ContactsPermission({
    Key? key,
    this.confirm,
    this.isGroup = false,
  }) : super(key: key);

  final Function? confirm;
  final bool isGroup;

  @override
  _ContactsPermissionState createState() => _ContactsPermissionState();
}

class _ContactsPermissionState extends State<ContactsPermission> {
  void _navigateToContacts(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.93,
          child: Contacts(
            confirm: widget.confirm,
            isGroup: widget.isGroup,
          ),
        );
      },
    );
  }

  Future _checkPermissions() async {
    await Permission.contacts.request();
    var status = await Permission.contacts.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      openAppSettings();
      Future.delayed(Duration(milliseconds: 50), () => exit(0));
    }

    if (status.isGranted) {
      _navigateToContacts(context);
      return;
    }

    if (await Permission.contacts.request().isGranted) {
      _navigateToContacts(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PermissionsTemplate(
      imageName: 'assets/images/authenticated/smartphone-illustrations.png',
      imagePadding: const EdgeInsets.only(
        left: 65.0,
        right: 65.0,
        bottom: 45.0,
      ),
      title: 'Contacts Access',
      subheader:
          'This helps you browse your contacts and save to shared camera rolls.',
      buttonText: 'Allow Contacts Access',
      onAllowAccess: () => _checkPermissions(),
    );
  }
}
