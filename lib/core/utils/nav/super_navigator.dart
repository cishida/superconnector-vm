import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/camera.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/camera_reply/camera_reply.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_permission/contacts_permission.dart';
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
    Function? sendVM,
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

      if (sendVM != null) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.93,
              child: Contacts(
                isGroup: true,
                sendVM: sendVM,
              ),
            );
          },
        );
      } else {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.93,
              child: Contacts(
                isGroup: false,
              ),
            );
          },
        );
      }
    } else {
      SuperNavigator.push(
        context: context,
        widget: ContactsPermission(
          sendVM: sendVM,
          isGroup: sendVM != null,
        ),
        fullScreen: false,
      );
    }
  }

  static void handleRecordNavigation({
    required BuildContext context,
    Connection? connection,
  }) async {
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      SuperNavigator.push(
        context: context,
        widget: connection == null
            ? Camera()
            : CameraReply(
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
