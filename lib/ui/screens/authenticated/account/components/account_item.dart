import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({
    Key? key,
    required this.leading,
    required this.title,
    this.subtitle = '',
    required this.onPressed,
  }) : super(key: key);

  final Widget leading;
  final String title;
  final String subtitle;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // behavior: HitTestBehavior.translucent,
      onTap: () => onPressed(),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    leading,
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 17.0,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: ConstantColors.DARK_TEXT,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: ConstantColors.DARK_TEXT.withOpacity(.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 1.0,
            color: ConstantColors.DIVIDER_GRAY,
          ),
        ],
      ),
    );
  }
}
