import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/go_back.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts.dart';

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
      widget: Contacts(),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            GoBack(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 65.0,
                      right: 65.0,
                      top: 66.0,
                      bottom: 45.0,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/authenticated/smartphone-illustrations.png',
                        // width: size.width * 0.686,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                        ),
                        child: Text(
                          'Contacts Access',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: ConstantColors.DARK_TEXT,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 44.0,
                          right: 44.0,
                        ),
                        child: Text(
                          'This helps you browse your contacts and start Superconnector Chats.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                          bottom: 65.0,
                          left: 45.0,
                          right: 45.0,
                        ),
                        child: ElevatedButton(
                          child: Text(
                            'Allow access',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await _checkPermissions();
                            print('request contacts or redirect');
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
