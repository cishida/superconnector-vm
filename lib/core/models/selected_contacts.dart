import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';

class SelectedContacts extends ChangeNotifier {
  List<Superuser> _superusers = [];
  List<Contact> _contacts = [];
  List<Connection> _connections = [];

  List<Connection> get connections => _connections;
  List<Superuser> get superusers => _superusers;
  List<Contact> get contacts => _contacts;

  void addConnection(Connection connection) {
    _connections.add(connection);
    notifyListeners();
  }

  void addSuperuser(Superuser superuser) {
    _superusers.add(superuser);
    notifyListeners();
  }

  void add(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void removeConnection(String id) {
    _connections.removeWhere((connection) => connection.id == id);
    notifyListeners();
  }

  void removeSuperuser(String phoneNumber) {
    _superusers
        .removeWhere((superuser) => superuser.phoneNumber == phoneNumber);
    notifyListeners();
  }

  void remove(Contact contact) {
    _contacts.remove(contact);
    notifyListeners();
  }

  bool containsConnection(Connection connection) {
    return _connections.where((e) => e.id == connection.id).length > 0;
  }

  bool containsSuperuser(Superuser superuser) {
    return _superusers
            .where((element) => element.phoneNumber == superuser.phoneNumber)
            .length >
        0;
  }

  bool contains(Contact contact) {
    return _contacts.contains(contact);
  }

  void reset() {
    _contacts = [];
    _superusers = [];
    _connections = [];
  }

  void resetConnections() {
    _connections = [];
  }

  bool isEmpty() {
    return _contacts.isEmpty && _superusers.isEmpty && _connections.isEmpty;
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
