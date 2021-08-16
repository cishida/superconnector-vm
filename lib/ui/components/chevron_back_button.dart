import 'package:flutter/material.dart';

class ChevronBackButton extends StatelessWidget {
  const ChevronBackButton({
    Key? key,
    required this.onBack,
    this.color = Colors.white,
    this.padding = const EdgeInsets.only(
      right: 10.0,
      left: 16.0,
      top: 5.0,
      bottom: 5.0,
    ),
  }) : super(key: key);

  final Function onBack;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onBack(),
          child: Padding(
            padding: padding,
            child: Icon(
              Icons.arrow_back_ios,
              color: color,
              size: 24.0,
            ),
          ),
        ),
      ],
    );
  }
}
