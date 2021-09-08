import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialLanding extends StatefulWidget {
  const InitialLanding({
    Key? key,
    required this.onButtonPress,
  }) : super(key: key);

  final Function onButtonPress;

  @override
  _InitialLandingState createState() => _InitialLandingState();
}

class _InitialLandingState extends State<InitialLanding> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isInputting = false;
  FocusNode _focusNode = FocusNode();
  final Duration _animationDuration = Duration(milliseconds: 275);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/unauthenticated/landing-background.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 21.0,
                child: AnimatedOpacity(
                  duration: _animationDuration,
                  opacity: _isInputting ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChevronBackButton(
                      // color: ConstantColors.PRIMARY,
                      onBack: () {
                        setState(() {
                          _isInputting = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                curve: Curves.easeOut,
                duration: _animationDuration,
                top: _isInputting ? 40 : size.height * .1175,
                child: AnimatedOpacity(
                  opacity: _isInputting ? 0 : 1,
                  duration: _animationDuration,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/unauthenticated/superconnector-icon-white.png',
                          width: 70,
                          height: 70,
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Text(
                          'Superconnector',
                          style: TextStyle(
                            fontSize: 36.0,
                            color: Colors.white.withOpacity(.8),
                            fontWeight: FontWeight.w900,
                            fontFamily: 'SourceSerifPro',
                            letterSpacing: -.85,
                          ),
                        ),
                        Text(
                          'Connect with your family',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white.withOpacity(.7),
                            fontWeight: FontWeight.w600,
                            letterSpacing: .15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                curve: Curves.easeOut,
                duration: _animationDuration,
                top: _isInputting ? size.height * .0892 : size.height * .5792,
                left: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedCrossFade(
                        crossFadeState: _isInputting
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: _animationDuration,
                        firstChild: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 24.0,
                            left: 5.0,
                          ),
                          child: Text(
                            'Log In or Sign Up to get started:',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            left: 5.0,
                          ),
                          child: Text(
                            'MOBILE NUMBER *',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isInputting = true;
                          });
                          Future.delayed(
                            Duration(milliseconds: 20),
                          ).then((value) {
                            _focusNode.requestFocus();
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: OnboardingTextField(
                          phoneNumberController: _phoneNumberController,
                          focusNode: _focusNode,
                          enabled: _isInputting,
                        ),
                      ),
                      AnimatedCrossFade(
                        crossFadeState: _isInputting
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: _animationDuration,
                        firstChild: Padding(
                            padding: const EdgeInsets.only(
                              top: 25.0,
                              left: 5.0,
                            ),
                            child: TermsAgreement()),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(
                            top: 15.0,
                            left: 5.0,
                            right: 10.0,
                          ),
                          child: Text(
                            'By providing your mobile number, you agree that it may be used to send you text messages to confirm your account.',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 5.0),
                      //   child: TermsAgreement(),
                      // ),
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     onButtonPress();
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 45.0),
              //     child: Image.asset(
              //       'assets/images/unauthenticated/passwordless-button.png',
              //       width: double.infinity,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class TermsAgreement extends StatelessWidget {
  const TermsAgreement({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: TextStyle(
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: 'By signing in you agree to our ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: 'Terms',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
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
            text: ' &\n',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: 'Privacy Policy.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
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
    );
  }
}

class OnboardingTextField extends StatelessWidget {
  const OnboardingTextField({
    Key? key,
    required this.phoneNumberController,
    required this.focusNode,
    this.enabled = false,
  }) : super(key: key);

  final TextEditingController phoneNumberController;
  final FocusNode focusNode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );

    TextStyle textFieldStyle = TextStyle(
      color: Colors.black.withOpacity(.4),
      fontWeight: FontWeight.w600,
      fontSize: 17.0,
      // backgroundColor: ConstantColors.SECONDARY,
    );

    return Stack(
      children: [
        TextField(
          focusNode: focusNode,
          autofocus: false,
          autocorrect: false,
          enabled: enabled,
          style: textFieldStyle,
          cursorColor: ConstantColors.PRIMARY,
          keyboardAppearance: Brightness.light,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            MaskedInputFormatter('(###) ###-####'),
          ],
          decoration: InputDecoration(
            labelText: 'Mobile Number *',
            labelStyle: textFieldStyle,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(
              68.0,
              14.0,
              5.0,
              13.0,
            ),
            disabledBorder: border,
            enabledBorder: border,
            border: border,
            focusedBorder: border,
            filled: true,
            fillColor: Colors.white.withOpacity(.7),
          ),
          controller: phoneNumberController,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onChanged: (text) {
            print(text);
          },
        ),
        Positioned(
          left: 21.0,
          top: 17.0,
          child: Text(
            '+1',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(.4),
            ),
          ),
        ),
        Positioned(
          left: 55.0,
          top: 11.0,
          bottom: 11.0,
          child: Container(
            width: 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.0),
              color: Colors.black.withOpacity(.2),
            ),
          ),
        ),
      ],
    );
    // return TextFormField(
    //   autofocus: false,
    //   autocorrect: false,
    //   keyboardAppearance: Brightness.light,
    //   keyboardType: TextInputType.phone,
    //   inputFormatters: [
    //     MaskedInputFormatter('(###) ###-####'),
    //   ],
    //   controller: _phoneNumberController,
    //   style: TextStyle(
    //     fontSize: 17.0,
    //     fontWeight: FontWeight.w600,
    //     color: Colors.black.withOpacity(.4),
    //   ),
    //   decoration: InputDecoration(
    //     contentPadding: const EdgeInsets.only(
    //       left: 27,
    //       top: 23,
    //       bottom: 23,
    //     ),
    //     fillColor: Colors.white.withOpacity(.7),
    //     labelText: 'Mobile number *',
    //     labelStyle: TextStyle(
    //       color: Colors.black.withOpacity(.4),
    //       fontSize: 17.0,
    //       fontWeight: FontWeight.w400,
    //     ),
    //     errorStyle: TextStyle(
    //       color: ConstantColors.ERROR_RED,
    //       height: 0.6,
    //     ),
    //   ).applyDefaults(
    //     Theme.of(context).inputDecorationTheme,
    //   ),
    // );
  }
}
