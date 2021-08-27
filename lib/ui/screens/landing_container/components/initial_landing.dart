import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialLanding extends StatelessWidget {
  const InitialLanding({
    Key? key,
    required this.onButtonPress,
  }) : super(key: key);

  final Function onButtonPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/unauthenticated/landing-background.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 26.0),
            child: Text(
              'Superconnector',
              style: TextStyle(
                fontSize: 42.0,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                // letterSpacing: -3,
                fontFamily: 'SourceSerifPro',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onButtonPress();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Image.asset(
                'assets/images/unauthenticated/passwordless-button.png',
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 38.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: 'By signing in you agree to our ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(.87),
                    ),
                  ),
                  TextSpan(
                    text: '\nTerms',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(.87),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = 'https://www.superconnector.com/terms';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                  ),
                  TextSpan(
                    text: ' & ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(.87),
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(.87),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = 'https://www.superconnector.com/privacy';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
