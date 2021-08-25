import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';

class BlockUtility {
  BlockUtility({
    required this.context,
    required this.superuser,
    required this.connection,
    required this.supercontacts,
    required this.selectedContacts,
  });

  final BuildContext context;
  final Superuser superuser;
  final Connection connection;
  final List<Supercontact> supercontacts;
  final SelectedContacts selectedContacts;

  void _toRecord() {
    selectedContacts.setContactsFromConnection(
      connection: connection,
      supercontacts: supercontacts,
    );
    SuperNavigator.handleRecordNavigation(context);
  }

  Future _showBlockedCard({
    required String blockedId,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            SuperDialog(
              title: 'Blocked',
              subtitle:
                  'If you continue, you’ll unblock them so you can send a reply.',
              primaryActionTitle: 'Continue',
              primaryAction: () async {
                await superuser.unblock(blockedId);
                Navigator.pop(context);
                _toRecord();
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

  Future handleBlockedRecordNavigation() async {
    String targetUserId =
        connection.userIds.firstWhere((e) => e != superuser.id);

    // if 1 on 1 connection and blocked user
    if (connection.userIds.length == 2 &&
        superuser.blockedUserIds.contains(targetUserId)) {
      await _showBlockedCard(
        blockedId: targetUserId,
      );

      return;
    }

    _toRecord();
  }
}
