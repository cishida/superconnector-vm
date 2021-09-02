import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class SelectedContacts extends ChangeNotifier {
  // List<Supercontact> _selectedSupercontacts = [];
  List<Contact> _selectedContacts = [];

  // List<Supercontact> get getSelectedSupercontacts {
  //   return _selectedSupercontacts;
  // }

  List<Contact> get contacts {
    return _selectedContacts;
  }

  // void addSupercontact(Supercontact supercontact) {
  //   _selectedSupercontacts.add(supercontact);
  //   notifyListeners();
  // }

  void add(Contact contact) {
    _selectedContacts.add(contact);
    notifyListeners();
  }

  // void removeSupercontact(String phoneNumber) {
  //   _selectedSupercontacts
  //       .removeWhere((supercontact) => supercontact.phoneNumber == phoneNumber);
  //   notifyListeners();
  // }

  void remove(Contact contact) {
    _selectedContacts.remove(contact);
    notifyListeners();
  }

  // bool containsSupercontact(Supercontact supercontact) {
  //   return _selectedSupercontacts
  //           .where((element) => element.phoneNumber == supercontact.phoneNumber)
  //           .length >
  //       0;
  // }

  bool contains(Contact contact) {
    return _selectedContacts.contains(contact);
  }

  void reset() {
    _selectedContacts = [];
    // _selectedSupercontacts = [];
  }

  bool isEmpty() {
    return _selectedContacts.isEmpty; // && _selectedSupercontacts.isEmpty;
  }

  // Future setContactsFromConnection({
  //   required Connection connection,
  //   required List<Supercontact> supercontacts,
  // }) async {
  //   reset();

  //   connection.userIds.forEach((userId) {
  //     List<Supercontact> tempSupercontacts =
  //         supercontacts.where((sc) => sc.targetUserId == userId).toList();
  //     if (tempSupercontacts.length > 0) {
  //       addSupercontact(tempSupercontacts.first);
  //     }
  //   });

  //   var status = await Permission.contacts.status;

  //   if (!status.isGranted) {
  //     return;
  //   }

  //   Iterable<Contact> contacts = await ContactsService.getContacts();
  //   connection.phoneNumberNameMap.forEach((key, value) async {
  //     List<Contact> tempContacts = contacts.where((contact) {
  //       if (contact.phones == null || contact.phones!.length == 0) {
  //         return false;
  //       }

  //       String formattedPhone = contact.phones!.first.value!.replaceAll(
  //         RegExp(r"\D"),
  //         "",
  //       );
  //       if (formattedPhone.length == 10) {
  //         formattedPhone = '1' + formattedPhone;
  //       }
  //       formattedPhone = '+' + formattedPhone;
  //       return formattedPhone == key;
  //     }).toList();
  //     if (tempContacts.length > 0) {
  //       addContact(tempContacts.first);
  //     }
  //   });
  //   return;
  // }
}
