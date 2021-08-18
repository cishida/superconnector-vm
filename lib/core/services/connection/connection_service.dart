import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';

class ConnectionService {
  final String? id;
  ConnectionService({this.id});

  final FirebaseFirestore instance = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference connectionCollection =
      FirebaseFirestore.instance.collection('connections');

  Future<Connection?> getConnectionFromSelected({
    required SelectedContacts selectedContacts,
  }) async {
    return null;
  }

  Future<Connection> getOrCreateConnection({
    required String currentUserId,
    required SelectedContacts selectedContacts,
    required List<Connection> connections,
    required FirebaseAnalytics analytics,
  }) async {
    List<String> userIds = selectedContacts.getSelectedSupercontacts
        .map((supercontact) => supercontact.targetUserId)
        .toList();
    userIds.add(currentUserId);
    // Connection? connection = connectionCollection.where('userIds', )
    var connectionDoc = connectionCollection.doc();
    Map<String, String> phoneNumberNameMap = {};
    selectedContacts.getSelectedContacts.forEach((contact) {
      String formattedPhone = contact.phones!.first.value!.replaceAll(
        RegExp(r"\D"),
        "",
      );

      if (formattedPhone.length == 10) {
        formattedPhone = '1' + formattedPhone;
      }
      formattedPhone = '+' + formattedPhone;

      String givenName = contact.givenName != null ? contact.givenName! : '';
      String familyName = contact.familyName != null ? contact.familyName! : '';

      String name = givenName +
          (givenName.isNotEmpty && familyName.isNotEmpty ? ' ' : '') +
          familyName;

      phoneNumberNameMap[formattedPhone] = name;
    });

    Connection connection = Connection(
      id: connectionDoc.id,
      userIds: userIds,
      phoneNumberNameMap: phoneNumberNameMap,
      // selectedContacts.getSelectedContacts.map(
      //   (contact) {
      //     String formattedPhone = contact.phones!.first.value!.replaceAll(
      //       RegExp(r"\D"),
      //       "",
      //     );

      //     if (formattedPhone.length == 10) {
      //       formattedPhone = '1' + formattedPhone;
      //     }
      //     formattedPhone = '+' + formattedPhone;
      //     return formattedPhone;
      //   },
      // ).toList(),
      streakCount: 1,
      created: DateTime.now(),
      mostRecentActivity: DateTime.now(),
    );

    for (var c in connections) {
      if (c.userIds.length == connection.userIds.length &&
          c.phoneNumberNameMap.length == connection.phoneNumberNameMap.length) {
        c.userIds.sort();
        connection.userIds.sort();

        List cKeys = c.phoneNumberNameMap.keys.toList();
        cKeys.sort();
        List connectionKeys = connection.phoneNumberNameMap.keys.toList();
        connectionKeys.sort();

        if (ListEquality().equals(
              c.userIds,
              connection.userIds,
            ) &&
            ListEquality().equals(
              cKeys,
              connectionKeys,
            )) {
          connection.id = c.id;
          return connection;
        }
      }
    }

    await connectionDoc.set(connection.toJson());
    analytics.logEvent(
      name: 'connection_created',
      parameters: <String, dynamic>{
        'id': connectionDoc.id,
        'userIds': connection.userIds,
      },
    );

    return connection;
  }

  // Connection from snapshot
  Connection? _connectionFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    if (snapshot.exists && data != null) {
      return Connection.fromJson(
        snapshot.id,
        Map<String, dynamic>.from(data),
      );
    } else {
      return null;
    }
  }

  // Get current user data doc stream
  Stream<Connection?>? get connection {
    if (id != null && id!.isNotEmpty) {
      return connectionCollection
          .doc(id)
          .snapshots()
          .map(_connectionFromSnapshot);
    }
    return null;
  }

  Future updateConnection(Map<String, dynamic> map) async {
    var db = FirebaseFirestore.instance;
    var batch = db.batch();
    final DocumentReference userCollectionDocument =
        connectionCollection.doc(id);

    batch.update(userCollectionDocument, map);

    return batch.commit();
  }

  Future<Connection?> getConnectionFromId(String id) async {
    final snapshot = await connectionCollection.doc(id).get();
    final data = snapshot.data();

    if (snapshot.exists && data != null) {
      return Connection.fromJson(
        id,
        data,
      );
    } else {
      return null;
    }
  }

  // Connections list from snapshot
  List<Connection> _connectionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Connection.fromJson(doc.id, doc.data());
    }).toList();
  }

  // Get Connections stream
  Stream<List<Connection>> getConnections(String userId) {
    return connectionCollection
        .where('userIds', arrayContains: userId)
        .orderBy('mostRecentActivity', descending: true)
        .snapshots()
        .map(_connectionListFromSnapshot);
  }

  Future update(String id, Map<String, dynamic> data) {
    return connectionCollection.doc(id).update(data);
  }
}
