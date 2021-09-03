import 'package:flutter/material.dart';

class ConnectionSearchTerm extends ChangeNotifier {
  String _term = '';

  String get() {
    return _term;
  }

  void set(String string) {
    _term = string;
    notifyListeners();
  }
}
