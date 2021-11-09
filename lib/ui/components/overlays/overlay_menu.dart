import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OverlayMenu extends StatefulWidget {
  const OverlayMenu({
    Key? key,
    required this.menuOptions,
  }) : super(key: key);

  final Map<String, Function> menuOptions;

  @override
  _OverlayMenuState createState() => _OverlayMenuState();
}

class _OverlayMenuState extends State<OverlayMenu> {
  List<Widget> _buildItems() {
    List<Widget> items = [];

    widget.menuOptions.forEach((key, value) {
      items.add(
        OverlayMenuItem(
          title: key,
          onTap: value,
        ),
      );
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black.withOpacity(0.7),
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context);
            },
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 250),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: -50.0,
                    horizontalOffset: 0.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: _buildItems(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OverlayMenuItem extends StatelessWidget {
  const OverlayMenuItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
