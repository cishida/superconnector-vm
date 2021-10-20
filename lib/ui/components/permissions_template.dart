import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';

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
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ConstantColors.DARK_BLUE,
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: AssetImage(
            //     'assets/images/authenticated/gradient-background.png',
            //   ),
            // ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 34.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChevronBackButton(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                      left: 0.0,
                      top: 21.0,
                    ),
                    onBack: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                      top: 12.0,
                      bottom: 30.0,
                    ),
                    child: Text(
                      subheader,
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      buttonText,
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: ConstantColors.PRIMARY,
                      onPrimary: ConstantColors.OFF_WHITE,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                    ),
                    onPressed: () => onAllowAccess(),
                  ),
                  // Expanded(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Padding(
                  //         padding: imagePadding,
                  //         child: Center(
                  //           child: Image.asset(
                  //             imageName,
                  //             // height: imageHeight,
                  //             // width: size.width * 0.686,
                  //           ),
                  //         ),
                  //       ),
                  //       Column(
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(
                  //               bottom: 12.0,
                  //             ),
                  //             child: Text(
                  //               title,
                  //               style: Theme.of(context).textTheme.headline5,
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.only(
                  //               left: 44.0,
                  //               right: 44.0,
                  //             ),
                  //             child: Text(
                  //               subheader,
                  //               textAlign: TextAlign.center,
                  //               style: Theme.of(context).textTheme.subtitle1,
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.only(
                  //               top: 40.0,
                  //               bottom: 65.0,
                  //               left: 45.0,
                  //               right: 45.0,
                  //             ),
                  //             child: ElevatedButton(
                  //               child: Text(
                  //                 buttonText,
                  //                 style: Theme.of(context).textTheme.button,
                  //               ),
                  //               style: ElevatedButton.styleFrom(
                  //                 minimumSize: Size(double.infinity, 50),
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(
                  //                     8.0,
                  //                   ),
                  //                 ),
                  //               ),
                  //               onPressed: () => onAllowAccess(),
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
