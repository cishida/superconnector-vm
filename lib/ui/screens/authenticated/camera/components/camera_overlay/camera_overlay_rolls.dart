import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';
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

    // var selectedContacts = Provider.of<SelectedContacts>(
    //   context,
    // );
    final Superuser? superuser = Provider.of<Superuser?>(context);

    return Consumer<List<Connection>>(
      builder: (context, connections, child) {
        return IntrinsicHeight(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Text(
                    //   connections.length.toString(),
                    //   style: style.copyWith(fontSize: 24.0),
                    // ),
                    Text(
                      'Connector',
                      textAlign: TextAlign.center,
                      style: style,
                    ),
                    // Text(
                    //   (selectedContacts.superusers.length +
                    //           selectedContacts.contacts.length +
                    //           1)
                    //       .toString(),
                    //   style: style.copyWith(fontSize: 24.0),
                    // ),
                    // Text(
                    //   'Selected',
                    //   style: style,
                    // ),
                    if (superuser != null)
                      SuperuserImage(
                        url: superuser.photoUrl,
                        radius: 21.0,
                        bordered: false,
                      ),
                    Text(
                      'Introducing',
                      textAlign: TextAlign.center,
                      style: style,
                    ),
                    CameraOverlayRollPhotos(),
                    // Image.asset(
                    //   'assets/images/authenticated/record/selected-camera-rolls-arrow.png',
                    //   width: 34.0,
                    //   height: 34.0,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
