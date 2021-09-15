import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superconnector_vm/core/models/user_connection/user_connection.dart';

class UserConnectionService {
  final String? id;
  UserConnectionService({this.id});

  final FirebaseFirestore instance = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference superuserCollection =
      FirebaseFirestore.instance.collection('superusers');

  // UserConnections list from snapshot
  List<UserConnection> _userConnectionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserConnection.fromJson(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }

  // Get UserConnections stream
  Stream<List<UserConnection>> getUserConnections(String userId) {
    return superuserCollection
        .doc(userId)
        .collection('userConnections')
        .snapshots()
        .map(_userConnectionListFromSnapshot);
  }
}
