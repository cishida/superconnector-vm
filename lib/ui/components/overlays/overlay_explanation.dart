import 'package:flutter/material.dart';

class OverlayExplanation extends StatelessWidget {
  const OverlayExplanation({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Colors.white,
                ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.white,
                ),
          ),
          SizedBox(
            height: 92.0,
          ),
        ],
      ),
    );
  }
}
