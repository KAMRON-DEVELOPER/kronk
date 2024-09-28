import 'package:flutter/material.dart';

class ToggleSettingsProvider extends ChangeNotifier {
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void toggleSettings() {
    // print('1) toggleSettings is starting, _isOpen = $_isOpen!!!');
    _isOpen = !_isOpen;
    // print('2) toggleSettings is ending, _isOpen = $_isOpen!!!');
    notifyListeners();
  }

  void closeSettings() {
    print('close is working');
    _isOpen = false;
    notifyListeners();
  }
}
