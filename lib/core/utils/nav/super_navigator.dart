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
    Function? confirm,
  }) async {
    var status = await Permission.contacts.status;

    if (status.isGranted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.93,
            child: Contacts(
              isGroup: confirm != null,
              confirm: confirm,
            ),
          );
        },
      );
    } else {
      SuperNavigator.push(
        context: context,
        widget: ContactsPermission(
          confirm: confirm,
          isGroup: confirm != null,
        ),
        fullScreen: false,
      );
    }
  }

  static void handleRecordNavigation({
    required BuildContext context,
    Connection? connection,
  }) async {
    // var cameraStatus = await Permission.camera.status;
    // var microphoneStatus = await Permission.microphone.status;

    SuperNavigator.push(
      context: context,
      widget: connection == null
          ? Camera()
          : CameraReply(
              connection: connection,
            ),
      fullScreen: false,
    );

    // if (cameraStatus.isGranted && microphoneStatus.isGranted) {
    //   SuperNavigator.push(
    //     context: context,
    //     widget: connection == null
    //         ? Camera()
    //         : CameraReply(
    //             connection: connection,
    //           ),
    //     fullScreen: false,
    //   );
    // } else {
    //   SuperNavigator.push(
    //     context: context,
    //     widget: RecordPermission(
    //       connection: connection,
    //     ),
    //     fullScreen: false,
    //   );
    // }
  }
}
