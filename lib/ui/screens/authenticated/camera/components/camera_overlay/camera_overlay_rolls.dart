import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_overlay/camera_overlay_roll_photos.dart';

class CameraOverlayRolls extends StatelessWidget {
  const CameraOverlayRolls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
    );

    var selectedContacts = Provider.of<SelectedContacts>(
      context,
    );

    return Consumer<List<Connection>>(
      builder: (context, connections, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            SuperNavigator.handleContactsNavigation(
              context: context,
              confirm: () {
                Navigator.of(context).pop();
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 3.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0),
              color: Colors.black.withOpacity(.25),
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          connections.length.toString(),
                          style: style.copyWith(fontSize: 24.0),
                        ),
                        Text(
                          'Camera\nRolls',
                          textAlign: TextAlign.center,
                          style: style,
                        ),
                        Text(
                          max(selectedContacts.connections.length, 1)
                              .toString(),
                          style: style.copyWith(fontSize: 24.0),
                        ),
                        Text(
                          'Selected',
                          style: style,
                        ),
                        CameraOverlayRollPhotos(),
                        Image.asset(
                          'assets/images/authenticated/record/selected-camera-rolls-arrow.png',
                          width: 34.0,
                          height: 34.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
