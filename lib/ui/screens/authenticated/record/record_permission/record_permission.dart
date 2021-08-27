import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/permissions_template.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/record.dart';

class RecordPermission extends StatelessWidget {
  const RecordPermission({Key? key}) : super(key: key);

  void _navigateToRecord(BuildContext context) {
    Navigator.of(context).pop();
    SuperNavigator.push(
      context: context,
      widget: Record(),
      fullScreen: false,
    );
  }

  Future _checkPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    // await Permission.camera.request();
    // var status = await Permission.camera.status;

    if (statuses.values.first.isDenied ||
        statuses.values.first.isPermanentlyDenied) {
      AppSettings.openAppSettings();
    } else {
      // if (statuses.values.first.isGranted || statuses.values.first.isLimited) {
      _navigateToRecord(context);
      return;
    }

    // if (await Permission.camera.request().isGranted) {
    //   _navigateToRecord(context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return PermissionsTemplate(
      imageName: 'assets/images/authenticated/a-sitting-person.png',
      imagePadding: const EdgeInsets.only(
        left: 16.0,
        right: 38.0,
        bottom: 53.0,
      ),
      title: 'Camera Access',
      subheader:
          'This helps you record video messages\nand share them with people.',
      buttonText: 'Allow Camera Access',
      onAllowAccess: () => _checkPermissions(context),
    );
  }
}
