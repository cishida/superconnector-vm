import 'package:flutter/material.dart';

class AuthenticatedController extends ChangeNotifier {
  int _pageIndex = 0;
  bool _isSearching = false;

  int get pageIndex {
    return _pageIndex;
  }

  bool get isSearching {
    return _isSearching;
  }

  void setIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  void setIsSearching(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }
}