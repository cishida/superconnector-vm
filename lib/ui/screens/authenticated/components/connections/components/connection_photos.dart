import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';

class ConnectionPhotos extends StatelessWidget {
  const ConnectionPhotos({
    Key? key,
    required this.photoUrls,
    required this.emptyImageCount,
    this.isMe = false,
  }) : super(key: key);

  final List<String> photoUrls;
  final int emptyImageCount;
  final bool isMe;

  List<Widget> _buildPhotos(BuildContext context) {
    List<Widget> widgets = [];

    final currentSuperuser = Provider.of<Superuser?>(
      context,
      listen: false,
    );

    if (currentSuperuser == null) {
      return [];
    }

    for (var i = 0; i < photoUrls.length + emptyImageCount; i++) {
      widgets.add(
        Positioned(
          child: Padding(
            padding: EdgeInsets.only(left: i * 10.0),
            child: SuperuserImage(
              url: isMe
                  ? currentSuperuser.photoUrl
                  : (i < photoUrls.length ? photoUrls[i] : ''),
              radius: 16.0,
              bordered: false,
            ),
          ),
        ),
      );
    }

    return widgets.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      width: 32 + (10 * (photoUrls.length + emptyImageCount - 1).toDouble()),
      child: Stack(
        children: _buildPhotos(context),
      ),
    );
  }
}
