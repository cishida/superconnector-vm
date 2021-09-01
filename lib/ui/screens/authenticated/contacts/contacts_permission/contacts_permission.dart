import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/permissions_template.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/relationships/relationships.dart';

class ContactsPermission extends StatefulWidget {
  const ContactsPermission({Key? key}) : super(key: key);

  @override
  _ContactsPermissionState createState() => _ContactsPermissionState();
}

class _ContactsPermissionState extends State<ContactsPermission> {
  void _navigateToContacts(BuildContext context) {
    Navigator.of(context).pop();
    SuperNavigator.push(
      context: context,
      widget: Relationships(),
      fullScreen: false,
    );
  }

  Future _checkPermissions() async {
    await Permission.contacts.request();
    var status = await Permission.contacts.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      AppSettings.openAppSettings();
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
          'This helps you browse your contacts\nand share VMs with them.',
      buttonText: 'Allow Contacts Access',
      onAllowAccess: () => _checkPermissions(),
    );
  }
}
