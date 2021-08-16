import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/go_back.dart';

class PermissionsTemplate extends StatelessWidget {
  const PermissionsTemplate({
    Key? key,
    required this.imageName,
    required this.imageHeight,
    required this.title,
    required this.subheader,
    required this.buttonText,
    required this.onAllowAccess,
  }) : super(key: key);

  final String imageName;
  final double imageHeight;
  final String title;
  final String subheader;
  final String buttonText;
  final Function onAllowAccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            GoBack(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 65.0,
                      right: 65.0,
                      top: 66.0,
                      bottom: 45.0,
                    ),
                    child: Center(
                      child: Image.asset(
                        imageName,
                        height: imageHeight,
                        // width: size.width * 0.686,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: ConstantColors.DARK_TEXT,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 44.0,
                          right: 44.0,
                        ),
                        child: Text(
                          subheader,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                          bottom: 65.0,
                          left: 45.0,
                          right: 45.0,
                        ),
                        child: ElevatedButton(
                          child: Text(
                            'Allow access',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                            ),
                          ),
                          onPressed: () => onAllowAccess(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
