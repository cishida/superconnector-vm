import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/onboarding.dart';
import 'package:superconnector_vm/ui/screens/home/home.dart';
// import 'package:superconnector_vm/core/services/auth/auth_service.dart';

class Authenticated extends StatefulWidget {
  const Authenticated({Key? key}) : super(key: key);

  @override
  _AuthenticatedState createState() => _AuthenticatedState();
}

class _AuthenticatedState extends State<Authenticated> {
  SuperuserService _superuserService = SuperuserService();

  @override
  void initState() {
    super.initState();
    _logAppOpen();
    _setAnalyticsProperties();
  }

  void _logAppOpen() async {
    final analytics = Provider.of<FirebaseAnalytics>(context, listen: false);
    await analytics.logAppOpen();
  }

  void _setAnalyticsProperties() async {
    FirebaseAnalytics analytics =
        Provider.of<FirebaseAnalytics>(context, listen: false);
    Superuser? superuser = Provider.of<Superuser?>(context, listen: false);

    if (superuser == null || superuser.id == '') {
      return;
    }

    await analytics.setUserId(superuser.id);
  }

  Future _setFCMToken(Superuser superuser) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    _firebaseMessaging.getToken().then((String? token) {
      if (token != null) {
        _superuserService.addToken(superuser.id, token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final superuser = context.watch<Superuser?>();
    // final _auth = Provider.of<AuthService>(context, listen: false);
    // _auth.signOut();

    if (superuser == null || superuser.id == '') {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      _setFCMToken(superuser);
    });

    final analytics = Provider.of<FirebaseAnalytics>(context);

    analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );

    if (!superuser.onboarded) {
      return Onboarding();
    } else {
      return Home();
    }
  }
}
