import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/components/snack_bars/light_snack_bar.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/relations/relations.dart';

class ConnectionGridMenu extends StatelessWidget {
  const ConnectionGridMenu({
    Key? key,
    required this.connection,
  }) : super(key: key);

  final Connection connection;

  void _showSnackbar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      LightSnackBar.createSnackBar(
        text: message,
      ),
    );

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //     backgroundColor: ConstantColors.DARK_BLUE,
    //     elevation: 0.0,
    //   ),
    // );
  }

  Future _blockUser({
    required Superuser superuser,
    required BuildContext context,
  }) async {
    String toBlockId =
        connection.userIds.firstWhere((userId) => userId != superuser.id);
    await superuser.block(toBlockId);
    Navigator.of(context).popUntil((route) => route.isFirst);

    _showSnackbar(
      context,
      'You blocked them.',
    );
  }

  Future _blockPressed({
    required BuildContext context,
    required Superuser superuser,
  }) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            SuperDialog(
              title: 'Block',
              subtitle:
                  'This stops you from receiving this person’s VMs. You can unblock them later if you want.',
              primaryActionTitle: 'Continue',
              primaryAction: () => _blockUser(
                superuser: superuser,
                context: context,
              ),
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

  Future _unblockPressed({
    required BuildContext context,
    required Superuser superuser,
  }) async {
    String toUnblockId =
        connection.userIds.firstWhere((userId) => userId != superuser.id);
    await superuser.unblock(toUnblockId);

    Navigator.of(context).popUntil((route) => route.isFirst);

    _showSnackbar(
      context,
      'You unblocked them.',
    );
  }

  Future _deleteConnection({
    required Superuser superuser,
    required BuildContext context,
  }) async {
    connection.deletedIds.add(superuser.id);
    final set = Set<String>.from(connection.deletedIds);
    connection.deletedIds = set.map((deletedId) => deletedId).toList();
    await connection.update();

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future _deletePressed({
    required Superuser superuser,
    required BuildContext context,
  }) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            SuperDialog(
              title: 'Delete Connection',
              subtitle:
                  'This permanently removes these videos from your history.',
              primaryActionTitle: 'Continue',
              primaryAction: () => _deleteConnection(
                superuser: superuser,
                context: context,
              ),
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

  void _editRelationPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.93,
          child: Relations(
            connection: connection,
          ),
        );
      },
    ).then((value) {
      Navigator.of(context).pop();
      _showSnackbar(
        context,
        'Your family relation has been updated.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    if (superuser == null) {
      return Container();
    }

    bool shouldBlock = true;
    String targetUserId =
        connection.userIds.firstWhere((userId) => userId != superuser.id);
    if (superuser.blockedUsers.keys.toList().contains(targetUserId)) {
      shouldBlock = false;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        // padding: const EdgeInsets.only(
        //   top: 65.0,
        //   right: 15.0,
        // ),
        constraints: BoxConstraints.expand(),
        color: Colors.black.withOpacity(0.7),
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context);
            },
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 250),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: -50.0,
                    horizontalOffset: 0.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    // shouldBlock
                    //     ? MenuChip(
                    //         onPressed: () => _blockPressed(
                    //           context: context,
                    //           superuser: superuser,
                    //         ),
                    //         title: 'Block',
                    //       )
                    //     : MenuChip(
                    //         onPressed: () => _unblockPressed(
                    //           context: context,
                    //           superuser: superuser,
                    //         ),
                    //         title: 'Unblock',
                    //       ),
                    GridMenuItem(
                      title: shouldBlock ? 'Block' : 'Unblock',
                      onTap: shouldBlock
                          ? () => _blockPressed(
                                context: context,
                                superuser: superuser,
                              )
                          : () => _unblockPressed(
                                context: context,
                                superuser: superuser,
                              ),
                    ),
                    GridMenuItem(
                      title: 'Delete',
                      onTap: () => _deletePressed(
                        superuser: superuser,
                        context: context,
                      ),
                    ),
                    GridMenuItem(
                      title: 'Edit Relation',
                      onTap: () => _editRelationPressed(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GridMenuItem extends StatelessWidget {
  const GridMenuItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
