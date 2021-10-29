import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/extensions/string_extension.dart';

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({
    Key? key,
    required this.title,
    required this.selected,
    this.imageHeight = 23.0,
    this.showBadge = false,
  }) : super(key: key);

  final String title;
  final bool selected;
  final double imageHeight;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    var color = selected ? Colors.white : ConstantColors.BOTTOM_NAV_UNSELECTED;
    var fontWeight = selected ? FontWeight.w700 : FontWeight.w600;
    Image image = Image.asset(
      'assets/images/authenticated/bottom_nav/bottom-nav-${title.toLowerCase()}.png',
      height: imageHeight,
      color: color,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // showBadge
        //     ? Badge(
        //         badgeContent: Text(''),
        //         toAnimate: false,
        //         badgeColor: ConstantColors.TURQUOISE,
        //         position: BadgePosition.topEnd(
        //           top: -11.0,
        //           end: -8.0,
        //         ),
        //         padding: EdgeInsets.all(
        //           7.0,
        //         ),
        //         child: Image.asset(
        //           'assets/images/home-tab-${title.toLowerCase()}.png',
        //           height: 22.0,
        //           color: color,
        //         ),
        //       )
        //     :
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: image,
        ),
        Text(
          title == 'records' ? 'Camera Rolls' : title.capitalize(),
          style: TextStyle(
            color: color,
            fontSize: 12.0,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }
}
