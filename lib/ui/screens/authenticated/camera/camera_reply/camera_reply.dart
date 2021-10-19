import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/camera.dart';

class CameraReply extends StatefulWidget {
  const CameraReply({
    Key? key,
    required this.connection,
  }) : super(key: key);

  final Connection connection;

  @override
  _CameraReplyState createState() => _CameraReplyState();
}

class _CameraReplyState extends State<CameraReply> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Camera(
            connection: widget.connection,
          ),
          // Positioned(
          //   top: 71.0,
          //   left: 0.0,
          //   child: ChevronBackButton(
          //     color: Colors.white,
          //     onBack: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: ConstantColors.DARK_BLUE,
        child: Container(
          alignment: Alignment.centerRight,
          height: 55.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Container(),
        ),
      ),
    );
  }
}
