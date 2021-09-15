import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superconnector_vm/core/models/video/video.dart';

class VideoService {
  // Collection references
  final CollectionReference videoCollection =
      FirebaseFirestore.instance.collection('videos');
  final CollectionReference superuserCollection =
      FirebaseFirestore.instance.collection('superusers');

  Future updateVideo(String videoId, Map<String, dynamic> map) async {
    var db = FirebaseFirestore.instance;
    var batch = db.batch();
    final DocumentReference videoDocument = videoCollection.doc(videoId);
    batch.update(videoDocument, map);
    return batch.commit();
  }

  // Superuser video list from snapshot
  List<Video> _videoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Video.fromJson(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }

  // // Get connection videos
  // Stream<List<Video>> getAllVideos(String connectionId) {
  //   return connectionCollection
  //       .doc(connectionId)
  //       .collection('videos')
  //       .orderBy('created', descending: false)
  //       .snapshots()
  //       .map(_videoListFromSnapshot);
  // }

  // Get connection video stream
  Stream<List<Video>>? getConnectionVideoStream(
    String connectionId, {
    int? limit,
  }) {
    Query query;
    if (limit == null) {
      query = videoCollection
          .where('connectionId', isEqualTo: connectionId)
          .orderBy('created', descending: true);
    } else {
      query = videoCollection
          .where('connectionId', isEqualTo: connectionId)
          .orderBy('created', descending: true)
          .limit(limit);
    }
    return query.snapshots().map(_videoListFromSnapshot);
  }

  Future<Video?> getVideo(String videoId) async {
    final snapshot = await videoCollection.doc(videoId).get();
    final data = snapshot.data();

    if (snapshot.exists && data != null) {
      return Video.fromJson(
        snapshot.id,
        data as Map<String, dynamic>,
      );
    } else {
      return null;
    }
  }
}
