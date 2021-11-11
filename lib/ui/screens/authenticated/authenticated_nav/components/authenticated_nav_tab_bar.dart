import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/providers/bottom_nav_provider.dart';
import 'package:superconnector_vm/ui/screens/authenticated/authenticated_nav/components/bottom_nav_button.dart';

class AuthenticatedNavTabBar extends StatelessWidget {
  const AuthenticatedNavTabBar({
    Key? key,
    required this.changeTab,
    this.showBadge = false,
  }) : super(key: key);

  final Function(int) changeTab;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    int pageIndex = Provider.of<BottomNavProvider>(
      context,
      listen: false,
    ).pageIndex;

    return TabBar(
      isScrollable: false,
      indicatorColor: Colors.transparent,
      automaticIndicatorColorAdjustment: false,
      onTap: (value) => changeTab(value),
      tabs: [
        Align(
          alignment: Alignment.centerLeft,
          child: BottomNavButton(
            title: 'camera-rolls',
            selected: pageIndex == 0,
            showBadge: showBadge,
          ),
        ),
        BottomNavButton(
          title: 'camera',
          selected: pageIndex == 1,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: BottomNavButton(
            title: 'settings',
            selected: pageIndex == 2,
            imageHeight: 24.0,
          ),
        ),
      ],
    );
  }
}
