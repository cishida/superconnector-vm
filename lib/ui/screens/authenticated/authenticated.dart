import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/onboarding.dart';
import 'package:superconnector_vm/ui/screens/home/home.dart';
// import 'package:superconnector_vm/core/services/auth/auth_service.dart';

class Authenticated extends StatefulWidget {
  const Authenticated({Key? key}) : super(key: key);

  @override
  _AuthenticatedState createState() => _AuthenticatedState();
}

class _AuthenticatedState extends State<Authenticated> {
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
    } else if (!superuser.onboarded) {
      return Onboarding();
    } else {
      return Home();
    }
  }
}
