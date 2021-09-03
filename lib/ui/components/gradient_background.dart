import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/authenticated/gradient-background.png',
              ),
            ),
          ),
          child: SafeArea(
            child: child,
          ),
        ),
      ),
    );
  }
}
