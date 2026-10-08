import 'package:flutter/material.dart';

class MenuState extends ChangeNotifier {
  static final MenuState _instance = MenuState._internal();
  factory MenuState() => _instance;
  MenuState._internal();

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}
