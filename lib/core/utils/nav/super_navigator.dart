import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_permission/contacts_permission.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/relations/relations.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/record.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/record_permission/record_permission.dart';

class SuperNavigator {
  static void push({
    required BuildContext context,
    required Widget widget,
    bool fullScreen = true,
    Function? callback,
  }) {
    Navigator.of(context)
        .push(
      MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return widget;
        },
        fullscreenDialog: fullScreen,
      ),
    )
        .then(
      (value) {
        if (callback != null) callback();
      },
    );
  }

  static void handleContactsNavigation({
    required BuildContext context,
    bool shouldShowHistory = false,
    Function? primaryAction,
  }) async {
    var status = await Permission.contacts.status;

    if (status.isGranted) {
      // Navigator.of(context).push(
      //   MaterialWithModalsPageRoute(
      //     builder: (context) {
      //       return FractionallySizedBox(
      //         heightFactor: 0.93,
      //         child: Relations(),
      //       );
      //     },
      //   ),
      // );

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.93,
            child: Relations(),
          );
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

  static void handleRecordNavigation({
    required BuildContext context,
    required Connection connection,
  }) async {
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      SuperNavigator.push(
        context: context,
        widget: Record(
          connection: connection,
        ),
        fullScreen: false,
      );
    } else {
      SuperNavigator.push(
        context: context,
        widget: RecordPermission(
          connection: connection,
        ),
        fullScreen: false,
      );
    }
  }
}
