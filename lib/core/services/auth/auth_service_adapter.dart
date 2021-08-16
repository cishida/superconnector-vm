import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/auth/auth_service.dart';
import 'package:superconnector_vm/core/services/auth/firebase_auth_service.dart';
import 'package:superconnector_vm/core/services/auth/mock_auth_service.dart';

enum AuthServiceType { firebase, mock }

class AuthServiceAdapter implements AuthService {
  AuthServiceAdapter({required AuthServiceType initialAuthServiceType})
      : authServiceTypeNotifier =
            ValueNotifier<AuthServiceType>(initialAuthServiceType) {
    _setup();
  }
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final MockAuthService _mockAuthService = MockAuthService();

  // Value notifier used to switch between [FirebaseAuthService] and [MockAuthService]
  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;
  AuthServiceType get authServiceType => authServiceTypeNotifier.value;
  AuthService get authService => authServiceType == AuthServiceType.firebase
      ? _firebaseAuthService
      : _mockAuthService;

  late StreamSubscription<SuperFirebaseUser> _firebaseAuthSubscription;
  late StreamSubscription<SuperFirebaseUser> _mockAuthSubscription;

  void _setup() {
    // Observable<User>.merge was considered here, but we need more fine grained control to ensure
    // that only events from the currently active service are processed
    _firebaseAuthSubscription = _firebaseAuthService.onAuthStateChanged.listen(
        (SuperFirebaseUser superFirebaseUser) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.add(superFirebaseUser);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.addError(error);
      }
    });
    _mockAuthSubscription = _mockAuthService.onAuthStateChanged.listen(
        (SuperFirebaseUser superFirebaseUser) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.add(superFirebaseUser);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.addError(error);
      }
    });
  }

  @override
  void dispose() {
    _firebaseAuthSubscription.cancel();
    _mockAuthSubscription.cancel();
    _onAuthStateChangedController.close();
    _mockAuthService.dispose();
    authServiceTypeNotifier.dispose();
  }

  final StreamController<SuperFirebaseUser> _onAuthStateChangedController =
      StreamController<SuperFirebaseUser>.broadcast();
  @override
  Stream<SuperFirebaseUser> get onAuthStateChanged =>
      _onAuthStateChangedController.stream;

  @override
  SuperFirebaseUser? currentSuperFirebaseUser() =>
      authService.currentSuperFirebaseUser();

  @override
  Future<SuperFirebaseUser?> signInWithPhone() => authService.signInWithPhone();

  @override
  Future<void> signOut() => authService.signOut();
}
