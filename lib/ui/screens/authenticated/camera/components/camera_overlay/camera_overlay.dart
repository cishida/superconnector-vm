import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_overlay/camera_overlay_rolls.dart';

class CameraOverlay extends StatefulWidget {
  const CameraOverlay({
    Key? key,
    required this.controller,
    required this.currentVideoSeconds,
    required this.toggleCamera,
    this.connection,
    this.pointerDown = false,
  }) : super(key: key);

  final CameraController? controller;
  final int currentVideoSeconds;
  final Function toggleCamera;
  final Connection? connection;
  final bool pointerDown;

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay>
    with TickerProviderStateMixin {
  final ConnectionService _connectionService = ConnectionService();
  late List<Superuser> _superusers = [];
  late AnimationController _animationController;

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
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _isRecording =
        widget.controller != null && widget.controller!.value.isRecordingVideo;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.connection != null && !_isRecording)
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
              opacity: _isRecording ? 1.0 : 0.0,
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
                  color: _isRecording &&
                          ConstantValues.VIDEO_TIME_LIMIT -
                                  widget.currentVideoSeconds <=
                              0
                      ? Colors.black.withOpacity(.3)
                      : Colors.white.withOpacity(.20),
                ),
                child: Text(
                  _isRecording &&
                          ConstantValues.VIDEO_TIME_LIMIT -
                                  widget.currentVideoSeconds <=
                              0
                      ? '${((ConstantValues.VIDEO_TIME_LIMIT + ConstantValues.VIDEO_OVERFLOW_LIMIT) - widget.currentVideoSeconds).toString()}s overflow'
                      : '${(ConstantValues.VIDEO_TIME_LIMIT - widget.currentVideoSeconds).toString()}s remaining',
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
            opacity: widget.pointerDown ? 1.0 : 0.0,
            duration: const Duration(
              milliseconds: 100,
            ),
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.6),
                shape: BoxShape.circle,
                border: Border.all(
                  width: 8,
                  color: ConstantColors.IMAGE_BORDER,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 93.0,
          child: AnimatedOpacity(
            opacity: !_isRecording ? 1.0 : 0.0,
            duration: const Duration(
              milliseconds: 100,
            ),
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 8,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 93.0 - 32.0,
          child: AnimatedOpacity(
            opacity: _isRecording ? 1.0 : 0.0,
            duration: const Duration(
              milliseconds: 100,
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  margin: EdgeInsets.only(
                    bottom: 16.0 * (1 - _animationController.value),
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.red.withOpacity(0.4),
                    shape: CircleBorder(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      16 + (16.0 * _animationController.value),
                    ),
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: ShapeDecoration(
                  color: Colors.red,
                  shape: CircleBorder(),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          bottom: 39.0,
          left: 0.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: !_isRecording ? 1.0 : 0.0,
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
                  'Tap for photo. Hold for video.',
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
        Positioned.fill(
          top: 51.0,
          right: 0.0,
          child: Align(
            alignment: Alignment.topRight,
            child: AnimatedOpacity(
              opacity: !_isRecording ? 1.0 : 0.0,
              duration: const Duration(
                milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          right: 5.0,
                          left: 5.0,
                        ),
                        child: Image.asset(
                          'assets/images/authenticated/record/camera-flash-button.png',
                          width: 42.0,
                          height: 42.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          right: 9.0,
                          left: 5.0,
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => widget.toggleCamera(),
                          child: Image.asset(
                            'assets/images/authenticated/record/camera-flip-button.png',
                            width: 42.0,
                            height: 42.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      SuperNavigator.handleContactsNavigation(
                        context: context,
                        confirm: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: CameraOverlayRolls(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
