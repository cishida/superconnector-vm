import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/auth/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final CollectionReference superuserCollection =
      FirebaseFirestore.instance.collection('superusers');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  SuperFirebaseUser _userFromFirebase(User? user) {
    return SuperFirebaseUser(
      id: user != null ? user.uid : '',
    );
  }

  @override
  Stream<SuperFirebaseUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  // Future _createUserProfile(User user) async {
  //   var batch = FirebaseFirestore.instance.batch();
  //   final superuserDoc = await superuserCollection.doc(user.uid).get();

  //   return batch.commit();
  // }

  @override
  Future<SuperFirebaseUser?> signInWithPhone() async {}

  @override
  SuperFirebaseUser? currentSuperFirebaseUser() {
    final User? user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
