import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/components/images/empty_image.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';

class CameraOverlayRollPhotos extends StatelessWidget {
  const CameraOverlayRollPhotos({
    Key? key,
  }) : super(key: key);

  List<Widget> _buildPhotos(
    Superuser? superuser,
    SelectedContacts selectedContacts,
  ) {
    List<Widget> widgets = [];

    if (superuser != null) {
      widgets.add(
        SuperuserImage(
          url: superuser.photoUrl,
          radius: 21.0,
          bordered: false,
        ),
      );
    }

    selectedContacts.superusers.forEach((superuser) async {
      widgets.add(
        CameraOverlayRollPhoto(
          superuser: superuser,
        ),
      );
    });

    for (var contact in selectedContacts.contacts) {
      widgets.add(
        CameraOverlayRollPhoto(
          contact: contact,
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(
      context,
    );
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 11.0,
      ),
      child: Column(
        children: _buildPhotos(
          superuser,
          selectedContacts,
        ),
      ),
    );
  }
}

class CameraOverlayRollPhoto extends StatelessWidget {
  const CameraOverlayRollPhoto({
    Key? key,
    this.superuser,
    this.contact,
  }) : super(key: key);

  final Superuser? superuser;
  final Contact? contact;

  @override
  Widget build(BuildContext context) {
    if (superuser == null && contact == null) {
      return Container();
    }

    Widget child;

    if (superuser != null) {
      child = SuperuserImage(
        url: superuser!.photoUrl,
        radius: 21.0,
        bordered: false,
      );
    } else {
      child = contact!.avatar != null
          ? CircleAvatar(
              backgroundImage: MemoryImage(contact!.avatar!),
              radius: 21.0,
            )
          : EmptyImage(
              size: 42.0,
              // isReversed: true,
            );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: child,
    );
  }
}
