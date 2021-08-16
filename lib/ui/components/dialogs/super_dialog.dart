import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class SuperDialog extends StatelessWidget {
  const SuperDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.primaryActionTitle,
    required this.primaryAction,
    this.secondaryActionTitle,
    this.secondaryAction,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String primaryActionTitle;
  final Function primaryAction;
  final String? secondaryActionTitle;
  final Function? secondaryAction;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      insetPadding: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Container(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 35.0,
            right: 30.0,
            top: 32.0,
            bottom: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.87),
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 17.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (secondaryAction != null)
                    GestureDetector(
                      onTap: () {
                        secondaryAction!();
                      },
                      child: Text(
                        secondaryActionTitle!,
                        style: TextStyle(
                          color: ConstantColors.PRIMARY,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(width: 40.0),
                  GestureDetector(
                    onTap: () {
                      primaryAction();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      primaryActionTitle,
                      style: TextStyle(
                        color: ConstantColors.PRIMARY,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
