import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    required this.currentIndex,
    required this.onContinue,
    Key? key,
  }) : super(key: key);

  final double currentIndex;
  final Function onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.bottomCenter,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DotsIndicator(
            dotsCount: 3,
            position: currentIndex,
            decorator: DotsDecorator(
              color: Colors.black.withOpacity(.32), // Inactive color
              activeColor: Colors.black,
              spacing: EdgeInsets.all(4.0),
              size: Size(
                6.0,
                6.0,
              ),
              activeSize: Size(
                6.0,
                6.0,
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     top: 46.0,
          //     bottom: 65.0,
          //     left: 45.0,
          //     right: 45.0,
          //   ),
          //   child: BarButton(
          //     title: currentIndex == 2 ? 'Turn On Notifications' : 'Continue',
          //     onPressed: onContinue,
          //   ),
          // ),
        ],
      ),
    );
  }
}
