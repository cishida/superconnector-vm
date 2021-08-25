import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/components/snack_bars/dark_snack_bar.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/block_list/components/blocked_tile.dart';

class BlockList extends StatelessWidget {
  const BlockList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Container();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ConstantColors.OFF_WHITE,
        brightness: Brightness.light,
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ConstantColors.OFF_WHITE,
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ChevronBackButton(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          top: 17.0,
                        ),
                        color: ConstantColors.PRIMARY,
                        onBack: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Text(
                    'Block List',
                    style: TextStyle(
                      color: Colors.black.withOpacity(.87),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: superuser.blockedUsers.keys.length,
                itemBuilder: (context, index) {
                  return BlockedTile(
                    superuserId: superuser.blockedUsers.keys.toList()[index],
                    unblock: () async {
                      await superuser
                          .unblock(superuser.blockedUsers.keys.toList()[index]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        DarkSnackBar.createSnackBar(
                          text: 'You unblocked them.',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
