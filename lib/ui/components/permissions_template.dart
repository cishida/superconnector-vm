import 'package:flutter/material.dart';
import 'package:superconnector_vm/ui/components/app_bars/custom_app_bar.dart';
import 'package:superconnector_vm/ui/components/go_back.dart';

class PermissionsTemplate extends StatelessWidget {
  const PermissionsTemplate({
    Key? key,
    required this.imageName,
    required this.imagePadding,
    required this.title,
    required this.subheader,
    required this.buttonText,
    required this.onAllowAccess,
  }) : super(key: key);

  final String imageName;
  final EdgeInsets imagePadding;
  final String title;
  final String subheader;
  final String buttonText;
  final Function onAllowAccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
      ),
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
                    padding: imagePadding,
                    child: Center(
                      child: Image.asset(
                        imageName,
                        // height: imageHeight,
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
                          style: Theme.of(context).textTheme.headline6,
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
                          style: Theme.of(context).textTheme.subtitle1,
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
                            buttonText,
                            style: Theme.of(context).textTheme.button,
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
