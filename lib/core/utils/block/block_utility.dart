import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';

class BlockUtility {
  BlockUtility({
    required this.context,
    required this.superuser,
    required this.connection,
  });

  final BuildContext context;
  final Superuser superuser;
  final Connection connection;

  static List<Video> unblockedVideos({
    required Superuser superuser,
    required List<Video> videos,
  }) {
    return videos.where((video) {
      bool unblocked = !superuser.blockedUsers.containsKey(video.superuserId);
      bool beforeBlock = superuser.blockedUsers[video.superuserId] != null &&
          video.created.isBefore(superuser.blockedUsers[video.superuserId]!);
      return unblocked || beforeBlock;
    }).toList();
  }

  void _toRecord() {
    // selectedContacts.setContactsFromConnection(
    //   connection: connection,
    //   supercontacts: supercontacts,
    // );
    SuperNavigator.handleRecordNavigation(
      context: context,
      connection: connection,
    );
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
    if (connection.userIds.length == 1) {
      _toRecord();
      return;
    }

    String targetUserId =
        connection.userIds.firstWhere((e) => e != superuser.id);

    // if 1 on 1 connection and blocked user
    if (connection.userIds.length == 2 &&
        superuser.blockedUsers.keys.contains(targetUserId)) {
      await _showBlockedCard(
        blockedId: targetUserId,
      );

      return;
    }

    _toRecord();
  }
}
