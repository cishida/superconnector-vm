import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superconnector_vm/core/models/caption/caption.dart';

class CaptionService {
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  final CollectionReference captionCollection =
      FirebaseFirestore.instance.collection('captions');

  // Collection references
  final CollectionReference superuserCollection =
      FirebaseFirestore.instance.collection('superusers');

  // Captions list from snapshot
  List<Caption> _captionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Caption.fromJson(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }

  // Get captions stream
  Stream<List<Caption>> getCaptions() {
    return captionCollection
        .orderBy('order')
        .snapshots()
        .map(_captionListFromSnapshot);
  }
}
