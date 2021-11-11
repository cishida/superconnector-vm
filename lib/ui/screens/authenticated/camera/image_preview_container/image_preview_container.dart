import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/providers/camera_provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/core/providers/bottom_nav_provider.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/core/utils/sms_utility.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_transform.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/components/video_meta_data.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/components/send_bottom_nav.dart';

class ImagePreviewContainer extends StatefulWidget {
  const ImagePreviewContainer({
    Key? key,
    required this.onReset,
    this.connection,
  }) : super(key: key);

  final Function onReset;
  final Connection? connection;

  @override
  _ImagePreviewContainerState createState() => _ImagePreviewContainerState();
}

class _ImagePreviewContainerState extends State<ImagePreviewContainer> {
  bool _pressed = false;

  Future _showInviteCard(
    List<String> phoneNumbers,
  ) async {
    if (phoneNumbers.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            SuperDialog(
              title: 'Confirmation',
              subtitle:
                  'Send them a Superconnector invitation so you can both use your shared camera roll.',
              primaryActionTitle: 'Continue',
              primaryAction: () async {
                String body = ConstantStrings.TARGETED_INVITE_COPY +
                    ConstantStrings.TESTFLIGHT_LINK;

                await SMSUtility.send(body, phoneNumbers);
                Navigator.pop(context);
              },
              secondaryActionTitle: 'Cancel',
              secondaryAction: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future sendVM() async {
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );
    final analytics = Provider.of<FirebaseAnalytics>(
      context,
      listen: false,
    );
    final connections = Provider.of<List<Connection>>(
      context,
      listen: false,
    );
    final cameraProvider = Provider.of<CameraProvider>(
      context,
      listen: false,
    );
    final currentSuperuser = Provider.of<Superuser?>(
      context,
      listen: false,
    );

    if (currentSuperuser == null) {
      return;
    }

    List<String> phoneNumbers = [];

    selectedContacts.resetConnections();

    if (widget.connection == null) {
      selectedContacts.superusers.forEach((superuser) async {
        selectedContacts.addConnection(connections
            .where((connection) =>
                connection.userIds.length == 2 &&
                connection.userIds.contains(superuser.id))
            .toList()
            .first);
      });

      selectedContacts.addConnection(connections
          .where(
            (connection) =>
                connection.userIds.length == 2 &&
                connection.userIds.contains(
                  ConstantStrings.SUPERCONNECTOR_ID,
                ),
          )
          .toList()
          .first);

      await Future.forEach(selectedContacts.contacts, (Contact contact) async {
        Connection connection =
            await ConnectionService().createConnectionFromContact(
          currentUserId: currentSuperuser.id,
          contact: contact,
          analytics: analytics,
        );

        if (connection.phoneNumberNameMap.isNotEmpty) {
          phoneNumbers = connection.phoneNumberNameMap.keys.toList();
        }
        selectedContacts.addConnection(connection);
      });
    }

    cameraProvider.navigateToRolls(context);
    await cameraProvider.createPhotos(
      selectedContacts.connections,
      currentSuperuser,
    );

    await cameraProvider.disposeCamera();
    await _showInviteCard(phoneNumbers);
    selectedContacts.reset();
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);
    final cameraProvider = Provider.of<CameraProvider>(
      context,
    );

    if (cameraProvider.imageFile == null) {
      return Container();
    }

    Widget sendButton = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (_pressed) {
          return;
        }

        setState(() {
          _pressed = true;
        });

        var selectedContacts = Provider.of<SelectedContacts>(
          context,
          listen: false,
        );

        if (widget.connection == null) {
          print('SEND PHOTO NO CONNECTION');
        } else {
          print('SEND PHOTO TO CONNECTION');
        }

        if (widget.connection == null) {
          SuperNavigator.handleContactsNavigation(
            context: context,
            confirm: sendVM,
          );
        } else {
          selectedContacts.addConnection(widget.connection!);
          sendVM();

          Navigator.of(context).popUntil((route) => route.isFirst);

          Provider.of<BottomNavProvider>(
            context,
            listen: false,
          ).setIndex(0);
        }

        setState(() {
          _pressed = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Image.asset(
          'assets/images/authenticated/record/send-vm-button.png',
          width: 46.0,
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ConstantColors.DARK_BLUE,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                if (cameraProvider.imageFile != null)
                  CameraTransform(
                    constraints: constraints,
                    isImage: true,
                    child: Image.file(
                      File(
                        cameraProvider.imageFile!.path,
                      ),
                    ),
                  ),
                Positioned(
                  top: 71.0 - 28.0,
                  left: 0.0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      Navigator.of(context).pop();
                      widget.onReset();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Image.asset(
                        'assets/images/authenticated/record/reset-button.png',
                        width: 18.0,
                      ),
                    ),
                  ),
                ),
                if (superuser != null)
                  VideoMetaData(
                    created: DateTime.now(),
                    superuser: superuser,
                    caption: cameraProvider.caption,
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: SendBottomNav(
          browseFilters: Container(),
          sendButton: sendButton,
        ),
        // bottomNavigationBar: BottomAppBar(
        //   color: ConstantColors.DARK_BLUE,
        //   child: AnimatedSize(
        //     duration: Duration(
        //       milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
        //     ),
        //     child: Container(
        //       alignment: Alignment.centerRight,
        //       height: cameraProvider.browsingFilters
        //           ? ConstantValues.BROWSE_FILTER_HEIGHT
        //           : ConstantValues.BOTTOM_NAV_HEIGHT,
        //       padding: const EdgeInsets.symmetric(
        //         horizontal: 20.0,
        //       ),
        //       child: cameraProvider.browsingFilters ? Container() : sendButton,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
