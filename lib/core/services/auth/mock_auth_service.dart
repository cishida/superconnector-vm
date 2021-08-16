import 'dart:async';

import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/auth/auth_service.dart';

/// Mock authentication service to be used for testing the UI
/// Keeps an in-memory store of registered accounts so that registration and sign in flows can be tested.
class MockAuthService implements AuthService {
  MockAuthService({
    this.startupTime = const Duration(milliseconds: 250),
    this.responseTime = const Duration(seconds: 2),
  }) {
    Future<void>.delayed(responseTime).then((_) {
      _add(null);
    });
  }
  final Duration startupTime;
  final Duration responseTime;

  late SuperFirebaseUser _currentSuperFirebaseUser;

  final StreamController<SuperFirebaseUser> _onAuthStateChangedController =
      StreamController<SuperFirebaseUser>();
  @override
  Stream<SuperFirebaseUser> get onAuthStateChanged =>
      _onAuthStateChangedController.stream;

  @override
  SuperFirebaseUser currentSuperFirebaseUser() {
    return _currentSuperFirebaseUser;
  }

  @override
  Future<SuperFirebaseUser?> signInWithPhone() async {
    await Future<void>.delayed(responseTime);
    return null;
  }

  @override
  Future<void> signOut() async {
    _add(null);
  }

  void _add(SuperFirebaseUser? superFirebaseUser) {
    if (superFirebaseUser != null) {
      _currentSuperFirebaseUser = superFirebaseUser;
      _onAuthStateChangedController.add(superFirebaseUser);
    }
  }

  @override
  void dispose() {
    _onAuthStateChangedController.close();
  }
}
