import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/go_back.dart';

// class Landing extends StatefulWidget {
//   const Landing({Key? key}) : super(key: key);

//   @override
//   _LandingState createState() => _LandingState();
// }

// class _LandingState extends State<Landing> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('Landing'),
//     );
//   }
// }

class Landing extends StatefulWidget {
  Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String? _verificationId;
  final CollectionReference superuserCollection =
      FirebaseFirestore.instance.collection('superusers');
  final CollectionReference supercontactCollection =
      FirebaseFirestore.instance.collection('supercontacts');
  final CollectionReference connectionCollection =
      FirebaseFirestore.instance.collection('connections');
  final _pageController = PageController(
    initialPage: 0,
  );
  double _currentIndex = 0;

  void verifyPhoneNumber() async {
    //Callback for when the user has already previously signed in with this phone number on this device
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackbar(
        "Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}",
      );
    };

    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showSnackbar(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    //Callback for when the code is sent
    PhoneCodeSent codeSent = (String verificationId, int? forceResendingToken) {
      showSnackbar('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      showSnackbar("verification code: " + verificationId);
      _verificationId = verificationId;
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
      showSnackbar("Failed to Verify Phone Number: $e");
    }
  }

  Future _createUserProfile(User user) async {
    final analytics = Provider.of<FirebaseAnalytics>(context);

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
      analytics.logSignUp(signUpMethod: 'phone_authentication');
    } else {
      analytics.logLogin();
    }

    return batch.commit();
  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsController.text,
      );

      final User user = (await _auth.signInWithCredential(credential)).user!;
      await _createUserProfile(user);

      // showSnackbar("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      // showSnackbar("Failed to sign in: " + e.toString());
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      if (_pageController.page != null &&
          _pageController.page! != _currentIndex) {
        setState(() {
          _currentIndex = _pageController.page!;
        });
      }
    });
  }

  List<Widget> _buildPages() {
    List<Widget> pages = [];
    pages.add(
      Container(
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
                _goToNextPage();
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
              child: Text(
                'By signing in you agree to our Terms & Privacy Policy.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  // fontFamily: 'SourceSerifPro',
                ),
              ),
            ),
          ],
        ),
      ),
    );
    BorderRadius borderRadius = BorderRadius.circular(36);

    OutlineInputBorder enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: ConstantColors.PRIMARY,
      ),
    );

    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: ConstantColors.PRIMARY,
      ),
    );

    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        width: 2.0,
        color: ConstantColors.ERROR_RED,
      ),
    );
    pages.add(
      SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GoBack(
              action: _goToPreviousPage,
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
                  // height: 15.0,
                  // width: 15.0,
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
                      enabledBorder: enabledBorder,
                      focusedBorder: focusedBorder,
                      errorBorder: errorBorder,
                      focusedErrorBorder: errorBorder,
                      border: OutlineInputBorder(
                        borderRadius: borderRadius,
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
                  verifyPhoneNumber();
                  _goToNextPage();
                },
              ),
            ),
          ],
        ),
      ),
    );

    pages.add(
      SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GoBack(
              action: _goToPreviousPage,
            ),
            SizedBox(
              height: 92.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Please enter your confirmation code.',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 33.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                child: TextFormField(
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
                    enabledBorder: enabledBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: errorBorder,
                    focusedErrorBorder: errorBorder,
                    border: OutlineInputBorder(
                      borderRadius: borderRadius,
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
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),

              //  TextFormField(
              //   controller: _smsController,
              //   decoration: const InputDecoration(
              //     labelText: 'Verification code',
              //   ),
              // ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 16.0,
              ),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  signInWithPhoneNumber();
                },
                child: Text("Sign in"),
              ),
            ),
          ],
        ),
      ),
    );
    return pages;
  }

  _goToPreviousPage() {
    FocusScope.of(context).unfocus();
    _pageController.previousPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  _goToNextPage() {
    FocusScope.of(context).unfocus();
    _pageController.nextPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_title),
      // ),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: PageView(
          // PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          // preloadPagesCount: 1,
          children: _buildPages(),
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8),
      //   child: Padding(
      //       padding: EdgeInsets.all(16),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           TextFormField(
      //             controller: _phoneNumberController,
      //             decoration: const InputDecoration(
      //               labelText: 'Phone number (+xx xxx-xxx-xxxx)',
      //             ),
      //           ),
      //           Container(
      //             padding: const EdgeInsets.symmetric(
      //               vertical: 16.0,
      //             ),
      //             alignment: Alignment.center,
      //             child: ElevatedButton(
      //               child: Text("Get current number"),
      //               onPressed: () async {
      //                 String? hint = await _autoFill.hint;
      //                 if (hint == null) {
      //                   return;
      //                 }
      //                 _phoneNumberController.text = hint;
      //               },
      //             ),
      //           ),
      //           Container(
      //             padding: const EdgeInsets.symmetric(
      //               vertical: 16.0,
      //             ),
      //             alignment: Alignment.center,
      //             child: ElevatedButton(
      //               child: Text("Verify Number"),
      //               onPressed: () async {
      //                 verifyPhoneNumber();
      //               },
      //             ),
      //           ),
      //           TextFormField(
      //             controller: _smsController,
      //             decoration: const InputDecoration(
      //               labelText: 'Verification code',
      //             ),
      //           ),
      //           Container(
      //             padding: const EdgeInsets.only(
      //               top: 16.0,
      //             ),
      //             alignment: Alignment.center,
      //             child: ElevatedButton(
      //               onPressed: () async {
      //                 signInWithPhoneNumber();
      //               },
      //               child: Text("Sign in"),
      //             ),
      //           ),
      //         ],
      //       )),
      // ),
    );
  }
}
