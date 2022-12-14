import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/components/underline.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/connection_photos.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/components/connection_grid_menu.dart';

class ConnectionGridHeader extends StatelessWidget {
  const ConnectionGridHeader({
    Key? key,
    required this.nameText,
    required List<Superuser> superusers,
    required this.connection,
  })  : _superusers = superusers,
        super(key: key);

  final String nameText;
  final List<Superuser> _superusers;
  final Connection connection;

  void _onTapName(BuildContext context) {
    // Only for 1 on 1 connections (for now)
    if (connection.userIds.length > 2) {
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        reverseTransitionDuration: Duration(milliseconds: 0),
        pageBuilder: (BuildContext context, _, __) {
          return ConnectionGridMenu(
            connection: connection,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    if (superuser == null) {
      return Container();
    }

    return Column(
      children: [
        Container(
          color: Colors.white,
          height: 55.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ChevronBackButton(
                    color: ConstantColors.DARK_BLUE_SECONDARY,
                    onBack: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              connection.userIds.contains(ConstantStrings.SUPERCONNECTOR_ID)
                  ? Padding(
                      padding: const EdgeInsets.only(right: 19),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              superuser.fullName,
                              style: TextStyle(
                                color: ConstantColors.DARK_BLUE_SECONDARY,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ConnectionPhotos(
                            photoUrls: [superuser.photoUrl],
                            emptyImageCount:
                                connection.phoneNumberNameMap.length,
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _onTapName(context),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 19),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                nameText,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.87),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ConnectionPhotos(
                              photoUrls:
                                  _superusers.map((e) => e.photoUrl).toList(),
                              emptyImageCount:
                                  connection.phoneNumberNameMap.length,
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
        Underline(
          color: ConstantColors.ED_GRAY,
        ),
      ],
    );
  }
}
