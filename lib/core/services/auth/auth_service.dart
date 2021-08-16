import 'dart:async';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';

abstract class AuthService {
  Stream<SuperFirebaseUser> get onAuthStateChanged;
  SuperFirebaseUser? currentSuperFirebaseUser();
  Future<SuperFirebaseUser?> signInWithPhone();
  Future<void> signOut();
  void dispose();
}
