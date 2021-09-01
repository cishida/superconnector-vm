import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_permission/contacts_permission.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/relationships/relationships.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/record.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/record_permission/record_permission.dart';

class SuperNavigator {
  static void push({
    required BuildContext context,
    required Widget widget,
    bool fullScreen = true,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return widget;
        },
        fullscreenDialog: fullScreen,
      ),
    );
  }

  static void handleContactsNavigation({
    required BuildContext context,
    bool shouldShowHistory = false,
    Function? primaryAction,
  }) async {
    var status = await Permission.contacts.status;

    if (status.isGranted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: Relationships(),
          );
          // return Relationships(
          //     // shouldShowHistory: shouldShowHistory,
          //     // primaryAction: primaryAction,
          //     );
        },
      );
    } else {
      SuperNavigator.push(
        context: context,
        widget: ContactsPermission(),
        fullScreen: false,
      );
    }
  }

  static void handleRecordNavigation(BuildContext context) async {
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      SuperNavigator.push(
        context: context,
        widget: Record(),
        fullScreen: false,
      );
    } else {
      SuperNavigator.push(
        context: context,
        widget: RecordPermission(),
        fullScreen: false,
      );
    }
  }
}
