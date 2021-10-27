import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superconnector_vm/core/models/photo/photo.dart';

class PhotoService {
  // Collection references
  final CollectionReference photoCollection =
      FirebaseFirestore.instance.collection('photos');
  final CollectionReference superuserCollection =
      FirebaseFirestore.instance.collection('superusers');

  Future updatePhoto(String photoId, Map<String, dynamic> map) async {
    var db = FirebaseFirestore.instance;
    var batch = db.batch();
    final DocumentReference photoDocument = photoCollection.doc(photoId);
    batch.update(photoDocument, map);
    return await batch.commit();
  }

  Future createPhoto(String photoId, Map<String, dynamic> map) async {
    final DocumentReference photoDocument = photoCollection.doc(photoId);
    return await photoDocument.set(map);
  }

  // Superuser photo list from snapshot
  List<Photo> _photoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Photo.fromJson(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }

  // // Get connection photos
  // Stream<List<Photo>> getAllPhotos(String connectionId) {
  //   return connectionCollection
  //       .doc(connectionId)
  //       .collection('photos')
  //       .orderBy('created', descending: false)
  //       .snapshots()
  //       .map(_photoListFromSnapshot);
  // }

  // Get connection photo stream
  Stream<List<Photo>>? getConnectionPhotoStream(
    String connectionId, {
    int? limit,
  }) {
    Query query;
    if (limit == null) {
      query = photoCollection
          .where('connectionId', isEqualTo: connectionId)
          .orderBy('created', descending: true);
    } else {
      query = photoCollection
          .where('connectionId', isEqualTo: connectionId)
          .orderBy('created', descending: true)
          .limit(limit);
    }
    return query.snapshots().map(_photoListFromSnapshot);
  }

  Future<Photo?> getPhoto(String photoId) async {
    final snapshot = await photoCollection.doc(photoId).get();
    final data = snapshot.data();

    if (snapshot.exists && data != null) {
      return Photo.fromJson(
        snapshot.id,
        data as Map<String, dynamic>,
      );
    } else {
      return null;
    }
  }
}
