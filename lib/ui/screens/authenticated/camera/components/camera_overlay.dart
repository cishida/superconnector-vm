import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';

class CameraOverlay extends StatefulWidget {
  const CameraOverlay({
    Key? key,
    required this.controller,
    required this.currentVideoSeconds,
    this.connection,
  }) : super(key: key);

  final CameraController controller;
  final int currentVideoSeconds;
  final Connection? connection;

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay> {
  final ConnectionService _connectionService = ConnectionService();
  late List<Superuser> _superusers = [];

  String _formatNames() {
    if (widget.connection == null) {
      return '';
    }

    if (widget.connection!.isExampleConversation) {
      return 'To Me';
    }

    String names = '';

    _superusers.forEach((element) {
      if (names.isEmpty) {
        names += element.fullName;
      } else {
        names += ', ' + element.fullName;
      }
    });

    widget.connection!.phoneNumberNameMap.values.forEach((element) {
      if (names.isEmpty) {
        names += element;
      } else {
        names += ', ' + element;
      }
    });

    return 'To ' + names;
  }

  Future _loadUserNames() async {
    final currentSuperuser = Provider.of<Superuser?>(context, listen: false);
    if (currentSuperuser == null || widget.connection == null) {
      return;
    }

    _superusers = await _connectionService.getConnectionUsers(
      connection: widget.connection!,
      currentSuperuser: currentSuperuser,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _loadUserNames();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.connection != null &&
            !widget.controller.value.isRecordingVideo)
          Positioned.fill(
            top: 71.0,
            right: 62.0,
            left: 62.0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: Colors.white.withOpacity(.20),
                ),
                child: Text(
                  _formatNames(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: 71.0,
          left: 50.0,
          right: 50.0,
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              opacity: widget.controller.value.isRecordingVideo ? 1.0 : 0.0,
              duration: const Duration(
                milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: widget.controller.value.isRecordingVideo &&
                          ConstantValues.VIDEO_TIME_LIMIT -
                                  widget.currentVideoSeconds <=
                              0
                      ? Colors.black.withOpacity(.3)
                      : Colors.white.withOpacity(.20),
                ),
                child: Text(
                  widget.controller.value.isRecordingVideo &&
                          ConstantValues.VIDEO_TIME_LIMIT -
                                  widget.currentVideoSeconds <=
                              0
                      ? '${((ConstantValues.VIDEO_TIME_LIMIT + ConstantValues.VIDEO_OVERFLOW_LIMIT) - widget.currentVideoSeconds).toString()} overflow'
                      : '${(ConstantValues.VIDEO_TIME_LIMIT - widget.currentVideoSeconds).toString()} remaining',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 93.0,
          child: AnimatedOpacity(
            opacity: widget.controller.value.isRecordingVideo ? 1.0 : 0.0,
            duration: const Duration(
              milliseconds: 100,
            ),
            child: Image.asset(
              'assets/images/authenticated/record/recording-button.png',
              width: 80.0,
            ),

            //  Image.asset(
            //   _isRecording
            //       ? 'assets/images/authenticated/record/recording-button.png'
            //       : 'assets/images/authenticated/record/record-button.png',
            //   width: 80.0,
            // ),
          ),
        ),
        Positioned(
          bottom: 93.0,
          child: AnimatedOpacity(
            opacity: !widget.controller.value.isRecordingVideo ? 1.0 : 0.0,
            duration: const Duration(
              milliseconds: 100,
            ),
            child: Image.asset(
              'assets/images/authenticated/record/record-button.png',
              width: 80.0,
            ),
          ),
        ),
        Positioned.fill(
          bottom: 39.0,
          left: 0.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: !widget.controller.value.isRecordingVideo ? 1.0 : 0.0,
              duration: const Duration(
                milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: Colors.white.withOpacity(.20),
                ),
                child: Text(
                  'Tap and hold to record',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
