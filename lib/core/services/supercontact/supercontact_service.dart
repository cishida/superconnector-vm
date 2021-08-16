import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';

class SupercontactService {
  final FirebaseFirestore instance = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference supercontactCollection =
      FirebaseFirestore.instance.collection('supercontacts');

  // Sync contacts
  // Note: Supercontacts have ids with the following format:
  // SuperuserId-PhoneNumber (where superuserId is the ownerId)
  // Allows for updating without reading
  Future<void> syncContacts(
    Superuser superuser,
    List<Contact> contacts,
  ) async {
    print('Sync contacts');

    if (superuser.numContacts == contacts.length) {
      return;
    }

    print('Running sync contacts');

    superuser.numContacts = contacts.length;

    List<WriteBatch> batchList = [instance.batch()];
    int operationCounter = 0;
    int batchIndex = 0;

    contacts.forEach((contact) {
      if (contact.phones != null && contact.phones!.length > 0) {
        contact.phones!.forEach((phone) {
          if (phone.value != null) {
            String formattedPhone = phone.value!.replaceAll(RegExp(r"\D"), "");

            if (formattedPhone.length >= 10) {
              if (formattedPhone.length == 10) {
                formattedPhone = '1' + formattedPhone;
              }
              formattedPhone = '+' + formattedPhone;

              // if (formattedPhone == '+19515007311') {
              String supercontactId = superuser.id + '-' + formattedPhone;

              var supercontactRef = supercontactCollection.doc(supercontactId);
              batchList[batchIndex].set(
                supercontactRef,
                {
                  'phoneNumber': formattedPhone,
                  'ownerUserId': superuser.id,
                },
                SetOptions(merge: true),
              );
              operationCounter++;
              if (operationCounter == 499) {
                batchList.add(instance.batch());
                batchIndex++;
                operationCounter = 0;
              }
              // }
            }
          }
        });
      }
    });

    batchList.forEach((batch) async {
      await batch.commit();
    });

    return superuser.update();
  }

  Future<Supercontact?> getSupercontactFromId(String id) async {
    final snapshot = await supercontactCollection.doc(id).get();
    final data = snapshot.data();

    if (snapshot.exists && data != null) {
      return Supercontact.fromJson(
        id,
        data,
      );
    } else {
      return null;
    }
  }

  // Supercontacts list from snapshot
  List<Supercontact> _supercontactListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Supercontact supercontact = Supercontact.fromJson(doc.id, doc.data());
      // supercontact.setUser();
      return supercontact;
    }).toList();
  }

  // Get Supercontacts stream
  Stream<List<Supercontact>> getSupercontacts(String ownerUserId) {
    return supercontactCollection
        .where('ownerUserId', isEqualTo: ownerUserId)
        .where('isSuperuser', isEqualTo: true)
        .where('targetUserId', isNotEqualTo: ownerUserId)
        .snapshots()
        .map(_supercontactListFromSnapshot);
  }

  Future update(String id, Map<String, dynamic> data) {
    return supercontactCollection.doc(id).update(data);
  }
}
