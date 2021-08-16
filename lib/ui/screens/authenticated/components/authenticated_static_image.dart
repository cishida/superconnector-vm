import 'package:flutter/material.dart';

class AuthenticatedStaticImage extends StatelessWidget {
  const AuthenticatedStaticImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * .59,
      width: size.width,
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            child: Container(
              height: 71.0,
              width: 53.0,
              child: Image.asset(
                'assets/images/authenticated/left-leaves.png',
              ),
            ),
          ),
          Positioned(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 123.0,
                  height: 149.82,
                  child: Image.asset(
                    'assets/images/authenticated/hanging-lamps.png',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: Container(
              width: 41.0,
              height: 66.0,
              child: Image.asset(
                'assets/images/authenticated/right-leaves.png',
              ),
            ),
          ),
          Positioned(
            width: size.width,
            bottom: 0.0,
            child: Image.asset(
              'assets/images/authenticated/sitting-people-conversing.png',
            ),
          ),
        ],
      ),
    );
  }
}
