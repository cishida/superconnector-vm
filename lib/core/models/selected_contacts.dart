import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';

class SelectedContacts extends ChangeNotifier {
  List<Supercontact> _selectedSupercontacts = [];
  List<Contact> _selectedContacts = [];

  List<Supercontact> get getSelectedSupercontacts {
    return _selectedSupercontacts;
  }

  List<Contact> get getSelectedContacts {
    return _selectedContacts;
  }

  void addSupercontact(Supercontact supercontact) {
    _selectedSupercontacts.add(supercontact);
    notifyListeners();
  }

  void addContact(Contact contact) {
    _selectedContacts.add(contact);
    notifyListeners();
  }

  void removeSupercontact(String phoneNumber) {
    _selectedSupercontacts
        .removeWhere((supercontact) => supercontact.phoneNumber == phoneNumber);
    notifyListeners();
  }

  void removeContact(Contact contact) {
    _selectedContacts.remove(contact);
    notifyListeners();
  }

  bool containsSupercontact(Supercontact supercontact) {
    return _selectedSupercontacts
            .where((element) => element.phoneNumber == supercontact.phoneNumber)
            .length >
        0;
  }

  bool containsContact(Contact contact) {
    return _selectedContacts.contains(contact);
  }

  void reset() {
    _selectedContacts = [];
    _selectedSupercontacts = [];
  }

  bool isEmpty() {
    return _selectedContacts.isEmpty && _selectedSupercontacts.isEmpty;
  }

  Future setContactsFromConnection({
    required Connection connection,
    required List<Supercontact> supercontacts,
  }) async {
    reset();

    connection.userIds.forEach((userId) {
      List<Supercontact> tempSupercontacts =
          supercontacts.where((sc) => sc.targetUserId == userId).toList();
      if (tempSupercontacts.length > 0) {
        addSupercontact(tempSupercontacts.first);
      }
    });

    Iterable<Contact> contacts = await ContactsService.getContacts();
    connection.phoneNumberNameMap.forEach((key, value) async {
      List<Contact> tempContacts = contacts.where((contact) {
        if (contact.phones == null || contact.phones!.length == 0) {
          return false;
        }

        String formattedPhone = contact.phones!.first.value!.replaceAll(
          RegExp(r"\D"),
          "",
        );
        if (formattedPhone.length == 10) {
          formattedPhone = '1' + formattedPhone;
        }
        formattedPhone = '+' + formattedPhone;
        return formattedPhone == key;
      }).toList();
      if (tempContacts.length > 0) {
        addContact(tempContacts.first);
      }
    });
    return;
  }
}
