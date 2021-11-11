import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/ui/components/painters/triangle_painter.dart';

class RecordOnboardingOverlay extends StatelessWidget {
  const RecordOnboardingOverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black.withOpacity(0.7),
          padding: EdgeInsets.only(
            bottom: ConstantValues.BOTTOM_NAV_HEIGHT,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 157.0,
                height: 75.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 6.0,
                ),
                margin: const EdgeInsets.only(
                  bottom: 1.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withOpacity(.25),
                ),
                child: Center(
                  child: Text(
                    'Tap for photo.\nHold for video.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: TrianglePainter(
                  isDown: true,
                  color: Colors.white.withOpacity(.25),
                ),
                child: Container(
                  height: 12.0,
                  width: 15.0,
                ),
              ),
              SizedBox(
                height: 150.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
