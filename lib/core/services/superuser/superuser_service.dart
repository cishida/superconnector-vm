import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/block/block_utility.dart';

class SuperuserService {
  final String? id;
  SuperuserService({this.id});

  final FirebaseFirestore instance = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference superuserCollection =
      FirebaseFirestore.instance.collection('superusers');
  final CollectionReference videoCollection =
      FirebaseFirestore.instance.collection('videos');

  Future addToken(String superuserId, String token) async {
    // if (superuserId != ConstantStrings.TEAM_SUPERCONNECTOR_ID) {
    var userRef = superuserCollection.doc(superuserId);
    await userRef.set(
      {
        'fcmTokens': [token],
      },
      SetOptions(merge: true),
    );
    // }
  }

  // Superuser from snapshot
  Superuser? _superuserFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    if (snapshot.exists && data != null) {
      return Superuser.fromJsonSetup(
        snapshot.id,
        Map<String, dynamic>.from(data as Map<String, dynamic>),
      );
    } else {
      return null;
    }
  }

  // Get current user data doc stream
  Stream<Superuser?>? get superuser {
    if (id != null && id!.isNotEmpty) {
      return superuserCollection
          .doc(id)
          .snapshots()
          .map(_superuserFromSnapshot);
    }
    return null;
  }

  Future updateSuperuser(Map<String, dynamic> map) async {
    var db = FirebaseFirestore.instance;
    var batch = db.batch();
    final DocumentReference userCollectionDocument =
        superuserCollection.doc(id);

    batch.update(userCollectionDocument, map);

    return batch.commit();
  }

  Future<Superuser?> getSuperuserFromId(String id) async {
    final snapshot = await superuserCollection.doc(id).get();
    final data = snapshot.data();

    if (snapshot.exists && data != null) {
      return Superuser.fromJsonSetup(
        id,
        data as Map<String, dynamic>,
      );
    } else {
      return null;
    }
  }

  Future<Superuser?> getSuperuserFromPhone(String phone) async {
    final snapshot = await superuserCollection
        .where('phoneNumber', isEqualTo: phone)
        .limit(1)
        .get();

    if (snapshot.docs.length > 0) {
      final data = snapshot.docs.first.data();
      return Superuser.fromJsonSetup(
        snapshot.docs.first.id,
        data as Map<String, dynamic>,
      );
    }
    return null;
  }

  // Superusers list from snapshot
  List<Superuser> _superuserListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Superuser.fromJsonSetup(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }

  // Get Superusers stream
  Stream<List<Superuser>> get superusers {
    return superuserCollection
        .where('onboarded', isEqualTo: true)
        .orderBy('created', descending: true)
        .snapshots()
        .map(_superuserListFromSnapshot);
  }

  Future update(String id, Map<String, dynamic> data) {
    return superuserCollection.doc(id).update(data);
  }

  Future<bool> isUsernameUnique(String username) async {
    var snapshot =
        await superuserCollection.where('username', isEqualTo: username).get();

    if (snapshot.docs.length > 0) {
      return false;
    }

    return true;
  }

  Future<int> syncNotifications(Superuser superuser) async {
    List<Video> videos = [];

    if (superuser.id.isEmpty) {
      return 0;
    }
    final videoSnap = await videoCollection
        .where(
          'unwatchedIds',
          arrayContains: superuser.id,
        )
        .get();

    videoSnap.docs.forEach((videoDoc) {
      videos.add(
        Video.fromJson(
          videoDoc.id,
          videoDoc.data() as Map<String, dynamic>,
        ),
      );
    });

    videos = BlockUtility.unblockedVideos(superuser: superuser, videos: videos);

    superuser.unseenNotificationCount = videos.length;
    await superuser.update();
    return superuser.unseenNotificationCount;
  }
}
