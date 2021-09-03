import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ConnectionSearchString extends ChangeNotifier {
  // List<Supercontact> _selectedSupercontacts = [];
  String _string = '';

  // List<Supercontact> get getSelectedSupercontacts {
  //   return _selectedSupercontacts;
  // }

  String get string {
    return _string;
  }

  void set(String string) {
    _string = string;
    notifyListeners();
  }
}
