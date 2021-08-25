import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/ui/components/chips/menu_chip.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';

class ConnectionGridMenu extends StatelessWidget {
  const ConnectionGridMenu({
    Key? key,
    required this.connection,
  }) : super(key: key);

  final Connection connection;

  Future _block(BuildContext context) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            SuperDialog(
              title: 'Block',
              subtitle:
                  'This stops you from receiving this person’s VMs. You can unblock them later if you want.',
              primaryActionTitle: 'Continue',
              primaryAction: () {
                print('Block');
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

  @override
  Widget build(BuildContext context) {
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
                    MenuChip(
                      onPressed: () => _block(context),
                      title: 'Block',
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
