import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';
import 'package:superconnector_vm/ui/components/underline.dart';

class BlockedTile extends StatefulWidget {
  BlockedTile({
    required this.superuserId,
    required this.unblock,
  });

  final String superuserId;
  final Function unblock;

  @override
  _BlockedTileState createState() => _BlockedTileState();
}

class _BlockedTileState extends State<BlockedTile> {
  SuperuserService _superuserService = SuperuserService();
  Superuser? _superuser;

  Future _loadSuperuser() async {
    if (mounted) {
      var temp = await _superuserService.getSuperuserFromId(widget.superuserId);
      setState(() {
        _superuser = temp;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSuperuser();
  }

  @override
  void didUpdateWidget(BlockedTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadSuperuser();
  }

  @override
  Widget build(BuildContext context) {
    if (_superuser == null) {
      return Container();
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ListTile(
            leading: SuperuserImage(
              radius: 21.0,
              url: _superuser?.photoUrl,
              bordered: false,
            ),
            // leading:
            title: Text(
              _superuser?.fullName ?? 'Loading...',
              style: TextStyle(
                color: ConstantColors.DARK_TEXT,
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(
              '@' + _superuser!.username,
              style: TextStyle(
                color: ConstantColors.DARK_TEXT,
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                widget.unblock();
              },
              child: Image.asset(
                'assets/images/authenticated/unblock-button.png',
                height: 20.0,
                width: 20.0,
              ),
            ),
          ),
        ),
        Underline(
          margin: const EdgeInsets.only(left: 85.0),
        ),
      ],
    );
  }
}