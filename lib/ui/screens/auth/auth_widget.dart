import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/screens/authenticated/authenticated.dart';
import 'package:superconnector_vm/ui/screens/landing/landing.dart';

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
          : Landing();
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
