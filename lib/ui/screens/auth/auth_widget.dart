import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/screens/authenticated/authenticated.dart';
import 'package:superconnector_vm/ui/screens/landing_container/landing_container.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({
    Key? key,
    required this.userSnapshot,
  }) : super(key: key);
  final AsyncSnapshot<SuperFirebaseUser> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData && userSnapshot.data!.id.isNotEmpty
          ? Authenticated()
          : LandingContainer();
    }

    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
