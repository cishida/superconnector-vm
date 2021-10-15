import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';

class SelectedContacts extends ChangeNotifier {
  List<Superuser> _selectedSuperusers = [];
  List<Contact> _selectedContacts = [];

  List<Superuser> get getSuperusers {
    return _selectedSuperusers;
  }

  List<Contact> get contacts {
    return _selectedContacts;
  }

  void addSuperuser(Superuser superuser) {
    _selectedSuperusers.add(superuser);
    notifyListeners();
  }

  void add(Contact contact) {
    _selectedContacts.add(contact);
    notifyListeners();
  }

  void removeSuperuser(String phoneNumber) {
    _selectedSuperusers
        .removeWhere((superuser) => superuser.phoneNumber == phoneNumber);
    notifyListeners();
  }

  void remove(Contact contact) {
    _selectedContacts.remove(contact);
    notifyListeners();
  }

  bool containsSuperuser(Superuser superuser) {
    return _selectedSuperusers
            .where((element) => element.phoneNumber == superuser.phoneNumber)
            .length >
        0;
  }

  bool contains(Contact contact) {
    return _selectedContacts.contains(contact);
  }

  void reset() {
    _selectedContacts = [];
    _selectedSuperusers = [];
  }

  bool isEmpty() {
    return _selectedContacts.isEmpty && _selectedSuperusers.isEmpty;
  }

  // Future setContactsFromConnection({
  //   required Connection connection,
  //   required List<Superuser> superusers,
  // }) async {
  //   reset();

  //   connection.userIds.forEach((userId) {
  //     List<Superuser> tempsuperusers =
  //         superusers.where((sc) => sc.targetUserId == userId).toList();
  //     if (tempsuperusers.length > 0) {
  //       addsuperuser(tempsuperusers.first);
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
