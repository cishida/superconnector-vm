import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/go_back.dart';
import 'package:superconnector_vm/ui/components/snack_bars/dark_snack_bar.dart';

class PhoneNumberEntry extends StatefulWidget {
  const PhoneNumberEntry({
    Key? key,
    required this.goBack,
    required this.setVerificationId,
  }) : super(key: key);

  final Function goBack;
  final Function(String) setVerificationId;

  @override
  _PhoneNumberEntryState createState() => _PhoneNumberEntryState();
}

class _PhoneNumberEntryState extends State<PhoneNumberEntry> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _verifyPhoneNumber() async {
    //Callback for when the user has already previously signed in with this phone number on this device
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      // showSnackbar(
      //   "Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}",
      // );
    };

    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      ScaffoldMessenger.of(context).showSnackBar(
        DarkSnackBar.createSnackBar(
          text: 'Phone number verification failed.',
        ),
      );
      // showSnackbar(
      //   'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
      // );
    };

    //Callback for when the code is sent
    PhoneCodeSent codeSent = (String verificationId, int? forceResendingToken) {
      ScaffoldMessenger.of(context).showSnackBar(
        DarkSnackBar.createSnackBar(
          text: 'Please check your phone for the verification code.',
        ),
      );
      // showSnackbar('Please check your phone for the verification code.');
      widget.setVerificationId(verificationId);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      // showSnackbar("verification code: " + verificationId);
      widget.setVerificationId(verificationId);
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
      // showSnackbar("Failed to Verify Phone Number: $e");
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData themeData = appTheme();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GoBack(
            action: widget.goBack,
          ),
          SizedBox(
            height: 92.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Enter your phone number to receive your\ntemporary confirmation code via text.',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 33.0,
          ),
          Stack(
            children: [
              Positioned(
                left: 45.0,
                top: 22.0,
                child: Text(
                  '+1',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: TextFormField(
                  autocorrect: false,
                  keyboardAppearance: Brightness.dark,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    MaskedInputFormatter('(###) ###-####'),
                  ],
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 45,
                      top: 23,
                      bottom: 23,
                    ),
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      color: ConstantColors.PRIMARY,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                    errorStyle: TextStyle(
                      color: ConstantColors.ERROR_RED,
                      height: 0.6,
                    ),
                  ).applyDefaults(
                    Theme.of(context).inputDecorationTheme,
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            alignment: Alignment.center,
            child: ElevatedButton(
              child: Text("Verify Number"),
              onPressed: () async {
                _verifyPhoneNumber();
              },
            ),
          ),
        ],
      ),
    );
  }
}
