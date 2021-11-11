import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/bar_button.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/screens/landing_container/components/landing_text_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:superconnector_vm/core/utils/extensions/string_extension.dart';

class InitialLanding extends StatefulWidget {
  const InitialLanding({
    Key? key,
    required this.setVerificationId,
    required this.setPhoneNumber,
  }) : super(key: key);

  // final Function onButtonPress;
  final Function setVerificationId;
  final Function setPhoneNumber;

  @override
  _InitialLandingState createState() => _InitialLandingState();
}

class _InitialLandingState extends State<InitialLanding>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isInputting = false;
  FocusNode _focusNode = FocusNode();
  final Duration _animationDuration = Duration(milliseconds: 330);
  bool _submitted = false;
  String _errorMessage = '';

  @override
  bool get wantKeepAlive => true;

  void _verifyPhoneNumber() async {
    if (_submitted) {
      return;
    }
    setState(() {
      _submitted = true;
      _errorMessage = '';
    });
    //Callback for when the user has already previously signed in with this phone number on this device
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
    };

    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        _errorMessage = 'Verification error: ' +
            (authException.message != null
                ? authException.message!.replaceAll('_', ' ').capitalize()
                : '');
        _submitted = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   DarkSnackBar.createSnackBar(
      //     text: 'Phone number verification failed.',
      //   ),
      // );
    };

    //Callback for when the code is sent
    PhoneCodeSent codeSent = (String verificationId, int? forceResendingToken) {
      widget.setVerificationId(verificationId);
      setState(() {
        _submitted = false;
      });
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      widget.setVerificationId(verificationId);
      setState(() {
        _submitted = false;
      });
    };

    try {
      String formattedPhoneNumber = _phoneNumberController.text.replaceAll(
        RegExp(r"\D"),
        "",
      );

      await _auth.verifyPhoneNumber(
        phoneNumber: '+1' + formattedPhoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isInputting = false;
          _errorMessage = '';
        });
        Future.delayed(
          Duration(milliseconds: 20),
        ).then((value) {
          _focusNode.unfocus();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: ConstantColors.DARK_BLUE,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              AnimatedPositioned(
                curve: Curves.easeOut,
                duration: Duration(milliseconds: 50),
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    (_isInputting ? 0 : -100),
                child: AnimatedOpacity(
                  curve: Curves.easeIn,
                  duration: _isInputting
                      ? _animationDuration
                      : Duration(milliseconds: 100),
                  opacity: _isInputting ? 1 : 0,
                  child: Container(
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 24.0,
                      ),
                      child: BarButton(
                        textColor: Colors.white,
                        backgroundColor: ConstantColors.PRIMARY,
                        title: 'Continue',
                        onPressed: _verifyPhoneNumber,
                        showLoading: _submitted,
                      ),
                    ),
                  ),
                ),
              ),
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
                top: _isInputting ? 40 : size.height * .075,
                child: AnimatedOpacity(
                  opacity: _isInputting ? 0 : 1,
                  duration: _animationDuration,
                  child: Container(
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/unauthenticated/superconnector-icon-white.png',
                            width: 80,
                            height: 80,
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            'Superconnector',
                            style: TextStyle(
                              fontSize: 34.0,
                              color: Colors.white.withOpacity(.8),
                              fontWeight: FontWeight.w900,
                              fontFamily: 'SourceSerifPro',
                              letterSpacing: -.85,
                            ),
                          ),
                          Text(
                            'Business Camera',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white.withOpacity(.8),
                              fontWeight: FontWeight.w600,
                              // letterSpacing: .15,
                            ),
                          ),
                        ],
                      ),
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
                              fontSize: 12.0,
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
                        child: LandingTextField(
                            textController: _phoneNumberController,
                            focusNode: _focusNode,
                            enabled: _isInputting,
                            onChanged: (text) {
                              widget.setPhoneNumber(text);
                            }),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    _errorMessage,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              Text(
                                'By providing your mobile number, you agree that it may be used to send you text messages to confirm your account.',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            text: 'By entering you agree to our ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'SourceSansPro',
            ),
          ),
          TextSpan(
            text: 'Terms',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              decoration: TextDecoration.underline,
              fontFamily: 'SourceSansPro',
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
              color: Colors.white,
              fontFamily: 'SourceSansPro',
            ),
          ),
          TextSpan(
            text: 'Privacy Policy.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              decoration: TextDecoration.underline,
              fontFamily: 'SourceSansPro',
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
