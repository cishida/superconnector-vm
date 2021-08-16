// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';

// enum PhoneAuthState {
//   Started,
//   CodeSent,
//   CodeResent,
//   Verified,
//   Failed,
//   Error,
//   AutoRetrievalTimeOut
// }

// class FirebasePhoneAuth {
//   static FirebaseAuth _auth = FirebaseAuth.instance;

//   static AuthCredential _authCredential;
//   static var actualCode, phone, status;
//   static StreamController<String> statusStream = StreamController.broadcast();
//   static StreamController<PhoneAuthState> phoneAuthState =
//       StreamController.broadcast();
//   static Stream stateStream = phoneAuthState.stream;

//   static instantiate({String phoneNumber}) async {
//     assert(phoneNumber != null);
//     phone = phoneNumber;
//     print(phone);
//     startAuth();
//   }

//   static dispose() {
//     statusStream.close();
//     phoneAuthState.close();
//   }

//   static startAuth() {
//     statusStream.stream
//         .listen((String status) => print("PhoneAuth: " + status));
//     addStatus('Phone auth started');
//     _auth
//         .verifyPhoneNumber(
//             phoneNumber: phone.toString(),
//             timeout: Duration(seconds: 60),
//             verificationCompleted: verificationCompleted,
//             verificationFailed: verificationFailed,
//             codeSent: codeSent,
//             codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
//         .then((value) {
//       addStatus('Code sent');
//     }).catchError((error) {
//       addStatus(error.toString());
//     });
//   }

//   static final PhoneCodeSent codeSent =
//       (String verificationId, [int forceResendingToken]) async {
//     actualCode = verificationId;
//     addStatus("\nEnter the code sent to " + phone);
//     addState(PhoneAuthState.CodeSent);
//   };

//   static final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//       (String verificationId) {
//     actualCode = verificationId;
//     addStatus("\nAuto retrieval time out");
//     addState(PhoneAuthState.AutoRetrievalTimeOut);
//   };

//   static final PhoneVerificationFailed verificationFailed =
//       (AuthException authException) {
//     addStatus('${authException.message}');
//     addState(PhoneAuthState.Error);
//     if (authException.message.contains('not authorized'))
//       addStatus('App not authroized');
//     else if (authException.message.contains('Network'))
//       addStatus('Please check your internet connection and try again');
//     else
//       addStatus('Something has gone wrong, please try later ' +
//           authException.message);
//   };

//   static final PhoneVerificationCompleted verificationCompleted =
//       (AuthCredential auth) {
//     addStatus('Auto retrieving verification code');

//     _auth.signInWithCredential(auth).then((AuthResult value) async {
//       if (value.user != null) {
//         addStatus(status = 'Authentication successful');
//         addState(PhoneAuthState.Verified);
//         await onAuthenticationSuccessful(value.user);
//       } else {
//         addState(PhoneAuthState.Failed);
//         addStatus('Invalid code/invalid authentication');
//       }
//     }).catchError((error) {
//       addState(PhoneAuthState.Error);
//       addStatus('Something has gone wrong, please try later $error');
//     });
//   };

//   static void signInWithPhoneNumber({String smsCode}) async {
//     _authCredential = PhoneAuthProvider.getCredential(
//         verificationId: actualCode, smsCode: smsCode);
//     print(_authCredential);

//     try {
//       final result = await _auth.signInWithCredential(_authCredential);
//       if (result.user != null) {
//         addStatus('Authentication successful');
//         addState(PhoneAuthState.Verified);
//         await onAuthenticationSuccessful(result.user);
//       } else {
//         print('Could not sign in with credential');
//       }
//       // }).catchError((error) {
//       //   addState(PhoneAuthState.Error);
//       //   addStatus(
//       //       'Something has gone wrong, please try later(signInWithPhoneNumber) $error');
//       // });
//     } on PlatformException catch (e) {
//       print('TEST: $e');
//       if (e.message.contains(
//           'The sms verification code used to create the phone auth credential is invalid')) {
//         print(e.message);
//       } else if (e.message.contains('The sms code has expired')) {
//         print(e.message);
//       }
//     }
//   }

//   static onAuthenticationSuccessful(FirebaseUser user) async {
//     //  TODO: handle authentication successful
//     print('On authentication successful method');

//     if (user != null) {
//       final userProfileDoc =
//           await Firestore.instance.collection('users').document(user.uid).get();
//       if (!userProfileDoc.exists) {
//         await DatabaseService(uid: user.uid).signUpUser(user.phoneNumber);
//       }
//     }
//   }

//   static addState(PhoneAuthState state) {
//     print(state);
//     phoneAuthState.sink.add(state);
//   }

//   static void addStatus(String s) {
//     statusStream.sink.add(s);
//     print(s);
//   }
// }
