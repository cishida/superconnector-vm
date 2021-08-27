import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/bar_button.dart';
import 'package:superconnector_vm/ui/components/go_back.dart';

class ConfirmationCodeEntry extends StatefulWidget {
  const ConfirmationCodeEntry({
    Key? key,
    required this.verificationId,
    required this.goBack,
  }) : super(key: key);

  final String? verificationId;
  final Function goBack;

  @override
  _ConfirmationCodeEntryState createState() => _ConfirmationCodeEntryState();
}

class _ConfirmationCodeEntryState extends State<ConfirmationCodeEntry> {
  final TextEditingController _smsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference superuserCollection =
      FirebaseFirestore.instance.collection('superusers');

  void _signInWithPhoneNumber() async {
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
        homeOnboardingStage: HomeOnboardingStage.connections,
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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 22.0),
          GoBack(
            action: widget.goBack,
          ),
          SizedBox(
            height: 182.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Please enter your confirmation code.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ConstantColors.ONBOARDING_TEXT,
                fontSize: 17.0,
              ),
            ),
          ),
          SizedBox(
            height: 42.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27.0),
              child: TextFormField(
                autofocus: true,
                autocorrect: false,
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.phone,
                controller: _smsController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: 25,
                    top: 23,
                    bottom: 23,
                  ),
                  labelText: 'Confirmation Code',
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
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 45.0,
            ),
            alignment: Alignment.center,
            child: BarButton(
              title: 'Continue',
              onPressed: _signInWithPhoneNumber,
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.only(
          //     top: 50.0,
          //   ),
          //   alignment: Alignment.center,
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       _signInWithPhoneNumber();
          //     },
          //     child: Text("Sign in"),
          //   ),
          // ),
        ],
      ),
    );
  }
}
