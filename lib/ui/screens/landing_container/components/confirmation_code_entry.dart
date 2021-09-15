import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';

class ConfirmationCodeEntry extends StatefulWidget {
  const ConfirmationCodeEntry({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
    required this.goBack,
  }) : super(key: key);

  final String? verificationId;
  final String phoneNumber;
  final Function goBack;

  @override
  _ConfirmationCodeEntryState createState() => _ConfirmationCodeEntryState();
}

class _ConfirmationCodeEntryState extends State<ConfirmationCodeEntry> {
  final TextEditingController _smsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference superuserCollection =
      FirebaseFirestore.instance.collection('superusers');
  // StreamController<ErrorAnimationType> _errorController =
  //     StreamController<ErrorAnimationType>();

  Future _signInWithPhoneNumber() async {
    try {
      if (widget.verificationId == null) {
        return;
      }

      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId!,
        smsCode: _smsController.text,
      );

      final User user = (await _auth.signInWithCredential(credential)).user!;
      await _createUserProfile(user);

      // showSnackbar("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      // showSnackbar("Failed to sign in: " + e.toString());
    }
  }

  Future _createUserProfile(User user) async {
    var batch = FirebaseFirestore.instance.batch();
    final superuserDoc = await superuserCollection.doc(user.uid).get();
    final phoneNumber = user.phoneNumber ?? '';
    final photoUrl = user.photoURL ?? '';
    Superuser? superuser;

    if (superuserDoc.exists) {
      var data = superuserDoc.data();
      if (data != null) {
        superuser = Superuser.fromJson(
          superuserDoc.id,
          data,
        );
      }
    }

    if (!superuserDoc.exists ||
        (superuser != null && superuser.phoneNumber == '')) {
      superuser = Superuser(
        id: user.uid,
        displayName: user.displayName ?? '',
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
        homeOnboardingStage: HomeOnboardingStage.connect,
        unseenNotificationCount: 1,
        created: DateTime.now(),
      );

      batch.set(
        superuserDoc.reference,
        superuser.toJson(),
      );
      // final analytics = Provider.of<FirebaseAnalytics>(context);
      // analytics.logSignUp(signUpMethod: 'phone_authentication');
    } else {
      // final analytics = Provider.of<FirebaseAnalytics>(context);
      // analytics.logLogin();
    }

    return batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasPrimaryFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 21.0, right: 8.0),
                child: ChevronBackButton(
                  onBack: () {
                    setState(() {
                      widget.goBack();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 41.0,
                        right: 10.0,
                      ),
                      child: Text(
                        'Enter the code we sent to your mobile number\n${widget.phoneNumber}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        'VERIFICATION CODE',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: .2,
                        ),
                      ),
                    ),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.phone,
                      keyboardAppearance: Brightness.light,
                      autoFocus: true,
                      textStyle: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(.7),
                      ),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(7),
                        fieldHeight: 48,
                        fieldWidth: 48,
                        activeFillColor: Colors.white.withOpacity(.7),
                        inactiveFillColor: Colors.white.withOpacity(.7),
                        selectedColor: Colors.white.withOpacity(.7),
                        activeColor: Colors.white.withOpacity(.7),
                        inactiveColor: Colors.white.withOpacity(.7),
                        selectedFillColor: Colors.white.withOpacity(.7),
                        fieldOuterPadding: const EdgeInsets.all(2),
                        borderWidth: 0.0,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      // errorAnimationController: _errorController,
                      controller: _smsController,
                      onCompleted: (v) async {
                        await _signInWithPhoneNumber();
                      },
                      onChanged: (value) {
                        print(value);
                        // setState(() {
                        //   currentText = value;
                        // });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.1629),
                      child: Text(
                        'Having trouble? Email support@superconnector.com',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(.7),
                          letterSpacing: .2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return SafeArea(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: <Widget>[
    //       SizedBox(height: 22.0),
    //       GoBack(
    //         action: widget.goBack,
    //       ),
    //       SizedBox(
    //         height: 182.0,
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 30.0),
    //         child: Text(
    //           'Please enter your confirmation code.',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             color: ConstantColors.ONBOARDING_TEXT,
    //             fontSize: 17.0,
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 42.0,
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 27.0),
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 27.0),
    //           child: TextFormField(
    //             autofocus: true,
    //             autocorrect: false,
    //             keyboardAppearance: Brightness.dark,
    //             keyboardType: TextInputType.phone,
    //             controller: _smsController,
    //             decoration: InputDecoration(
    //               contentPadding: const EdgeInsets.only(
    //                 left: 25,
    //                 top: 23,
    //                 bottom: 23,
    //               ),
    //               labelText: 'Confirmation Code',
    //               labelStyle: TextStyle(
    //                 color: ConstantColors.PRIMARY,
    //                 fontSize: 16.0,
    //                 fontWeight: FontWeight.w400,
    //               ),
    //               errorStyle: TextStyle(
    //                 color: ConstantColors.ERROR_RED,
    //                 height: 0.6,
    //               ),
    //             ).applyDefaults(
    //               Theme.of(context).inputDecorationTheme,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         padding: const EdgeInsets.symmetric(
    //           vertical: 50.0,
    //           horizontal: 45.0,
    //         ),
    //         alignment: Alignment.center,
    //         child: BarButton(
    //           title: 'Continue',
    //           onPressed: _signInWithPhoneNumber,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
