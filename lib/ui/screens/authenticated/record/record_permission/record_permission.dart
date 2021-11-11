// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:superconnector_vm/core/models/connection/connection.dart';
// import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
// import 'package:superconnector_vm/ui/components/permissions_template.dart';
// import 'package:superconnector_vm/ui/screens/authenticated/camera/camera_reply/camera_reply.dart';

// class RecordPermission extends StatelessWidget {
//   const RecordPermission({
//     Key? key,
//     this.connection,
//     this.callback,
//   }) : super(key: key);

//   final Connection? connection;
//   final Function? callback;

//   void _navigateToRecord({
//     required BuildContext context,
//   }) {
//     Navigator.of(context).pop();
//     SuperNavigator.push(
//       context: context,
//       widget: CameraReply(
//         connection: connection!,
//       ),
//       fullScreen: false,
//     );
//   }

//   Future _checkPermissions(BuildContext context) async {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.camera,
//       Permission.microphone,
//     ].request();
//     // await Permission.camera.request();
//     // var status = await Permission.camera.status;

//     if (statuses.values.first.isDenied ||
//         statuses.values.first.isPermanentlyDenied) {
//       openAppSettings();
//       Future.delayed(Duration(milliseconds: 50), () => exit(0));
//     } else {
//       // if (statuses.values.first.isGranted || statuses.values.first.isLimited) {
//       //
//       if (connection != null) {
//         _navigateToRecord(context: context);
//       } else if (callback != null) {
//         callback!();
//         Navigator.of(context).pop();
//       }
//       return;
//     }

//     // if (await Permission.camera.request().isGranted) {
//     //   _navigateToRecord(context);
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PermissionsTemplate(
//       imageName: 'assets/images/authenticated/a-sitting-person.png',
//       imagePadding: const EdgeInsets.only(
//         left: 16.0,
//         right: 38.0,
//         bottom: 53.0,
//       ),
//       title: 'Camera Access',
//       subheader:
//           'This helps you use your camera for business\noperations and integrate with business apps.',
//       buttonText: 'Allow Camera Access',
//       onAllowAccess: () => _checkPermissions(context),
//     );
//   }
// }
