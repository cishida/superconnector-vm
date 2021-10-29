import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';

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
          padding: const EdgeInsets.symmetric(
            vertical: 7.0,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 19.0,
                  right: 12.0,
                ),
                child: SuperuserImage(
                  url: _superuser!.photoUrl,
                  radius: 19.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _superuser!.fullName,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _superuser!.phoneNumber,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black.withOpacity(.5),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  right: 22.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.unblock();
                  },
                  child: Image.asset(
                    'assets/images/authenticated/unblock-button.png',
                    height: 20.0,
                    width: 20.0,
                    color: Colors.black.withOpacity(.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
