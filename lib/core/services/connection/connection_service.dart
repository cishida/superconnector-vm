import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';

class ConnectionService {
  final String? id;
  ConnectionService({this.id});

  final FirebaseFirestore instance = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference connectionCollection =
      FirebaseFirestore.instance.collection('connections');
  final SuperuserService _superuserService = SuperuserService();

  // Future<Connection?> getConnectionFromSelected({
  //   required SelectedContacts selectedContacts,
  //   required List<Connection> connections,
  // }) async {
  //   return null;
  // }

  Future<Connection?> getConnectionFromUserIds(List<String> ids) async {
    final snapshot = await connectionCollection
        .where('userIds', arrayContains: ids[0])
        .where('userIds', arrayContains: ids[1])
        .limit(1)
        .get();

    if (snapshot.docs.length == 0) {
      return null;
    }

    var doc = snapshot.docs.first;
    var data = doc.data();

    if (data != null) {
      return Connection.fromJson(
        doc.id,
        data as Map<String, dynamic>,
      );
    } else {
      return null;
    }
  }

  Future<List<Superuser>> getConnectionUsers({
    required Connection connection,
    required Superuser currentSuperuser,
  }) async {
    List<Superuser> superusers = [];

    for (var i = 0; i < connection.userIds.length; i++) {
      List<String> ids = superusers.map((e) => e.id).toList();

      if (connection.userIds[i] != currentSuperuser.id) {
        Superuser? superuser = await SuperuserService().getSuperuserFromId(
          connection.userIds[i],
        );
        if (superuser != null && !ids.contains(superuser.id)) {
          superusers.add(superuser);
        }
      }
    }

    return superusers;
  }

  // Future<Connection> createConnection({
  //   required String currentUserId,
  //   required SelectedContacts selectedContacts,
  //   required FirebaseAnalytics analytics,
  //   required String tag,
  // }) async {
  //   var connectionDoc = connectionCollection.doc();

  //   List<String> userIds = [];
  //   userIds.add(currentUserId);

  //   Map<String, String> phoneNumberNameMap = {};
  //   selectedContacts.getSelectedContacts.forEach((contact) {
  //     String formattedPhone = contact.phones!.first.value!.replaceAll(
  //       RegExp(r"\D"),
  //       "",
  //     );

  //     if (formattedPhone.length == 10) {
  //       formattedPhone = '1' + formattedPhone;
  //     }
  //     formattedPhone = '+' + formattedPhone;

  //     String givenName = contact.givenName != null ? contact.givenName! : '';
  //     String familyName = contact.familyName != null ? contact.familyName! : '';

  //     String name = givenName +
  //         (givenName.isNotEmpty && familyName.isNotEmpty ? ' ' : '') +
  //         familyName;

  //     phoneNumberNameMap[formattedPhone] = name;
  //   });

  //   Connection connection = Connection(
  //     id: connectionDoc.id,
  //     userIds: userIds,
  //     tags: {
  //       currentUserId: tag,
  //     },
  //     phoneNumberNameMap: phoneNumberNameMap,
  //     streakCount: 1,
  //     created: DateTime.now(),
  //     mostRecentActivity: DateTime.now(),
  //   );

  //   await connectionDoc.set(connection.toJson());
  //   analytics.logEvent(
  //     name: 'connection_created',
  //     parameters: <String, dynamic>{
  //       'id': connectionDoc.id,
  //       'userIds': connection.userIds,
  //     },
  //   );

  //   return connection;
  // }

  Future<Map<String, dynamic>> getOrCreateConnection({
    required String currentUserId,
    required SelectedContacts selectedContacts,
    required List<Connection> connections,
    required FirebaseAnalytics analytics,
    required String tag,
  }) async {
    List<String> userIds = [];
    //selectedContacts.getSelectedSupercontacts
    // .map((supercontact) => supercontact.targetUserId)
    // .toList();
    userIds.add(currentUserId);
    var connectionDoc = connectionCollection.doc();
    Map<String, String> phoneNumberNameMap = {};

    for (var contact in selectedContacts.contacts) {
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

      final Superuser? superuser =
          await _superuserService.getSuperuserFromPhone(formattedPhone);

      if (superuser == null) {
        phoneNumberNameMap[formattedPhone] = name;
      } else {
        userIds.add(superuser.id);
      }
    }

    Connection connection = Connection(
      id: connectionDoc.id,
      userIds: userIds,
      tags: {
        currentUserId: tag,
      },
      phoneNumberNameMap: phoneNumberNameMap,
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
          // connection.id = c.id;
          c.tags.addAll({
            currentUserId: tag,
          });
          c.update();
          return {
            'connection': c,
            'wasCreated': false,
          };
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

    return {
      'connection': connection,
      'wasCreated': true,
    };
  }

  // Connection from snapshot
  Connection? _connectionFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    if (snapshot.exists && data != null) {
      return Connection.fromJson(
        snapshot.id,
        Map<String, dynamic>.from(data as Map<String, dynamic>),
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
        data as Map<String, dynamic>,
      );
    } else {
      return null;
    }
  }

  // Connections list from snapshot
  List<Connection> _connectionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Connection.fromJson(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
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
