import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/components/chips/menu_chip.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/components/snack_bars/dark_snack_bar.dart';

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
      DarkSnackBar.createSnackBar(
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
        padding: const EdgeInsets.only(
          top: 65.0,
          right: 15.0,
        ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    shouldBlock
                        ? MenuChip(
                            onPressed: () => _blockPressed(
                              context: context,
                              superuser: superuser,
                            ),
                            title: 'Block',
                          )
                        : MenuChip(
                            onPressed: () => _unblockPressed(
                              context: context,
                              superuser: superuser,
                            ),
                            title: 'Unblock',
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
