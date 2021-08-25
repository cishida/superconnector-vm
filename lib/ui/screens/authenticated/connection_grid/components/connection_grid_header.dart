import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/connection_photos.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 55.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ChevronBackButton(
              color: ConstantColors.PRIMARY,
              onBack: () {
                Navigator.pop(context);
              },
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              print('username tapped');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 19),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      nameText,
                      style: TextStyle(
                        color: ConstantColors.PRIMARY,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ConnectionPhotos(
                    photoUrls: _superusers.map((e) => e.photoUrl).toList(),
                    emptyImageCount: connection.phoneNumberNameMap.length,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
