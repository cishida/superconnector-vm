import 'package:flutter/material.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';

class ConnectionPhotos extends StatelessWidget {
  const ConnectionPhotos({
    Key? key,
    required this.photoUrls,
    required this.emptyImageCount,
  }) : super(key: key);

  final List<String> photoUrls;
  final int emptyImageCount;

  List<Widget> _buildPhotos() {
    List<Widget> widgets = [];

    for (var i = 0; i < photoUrls.length + emptyImageCount; i++) {
      widgets.add(
        Positioned(
          child: Padding(
            padding: EdgeInsets.only(left: i * 10.0),
            child: SuperuserImage(
              url: i < photoUrls.length ? photoUrls[i] : '',
              radius: 16.0,
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
        children: _buildPhotos(),
      ),
    );
  }
}
