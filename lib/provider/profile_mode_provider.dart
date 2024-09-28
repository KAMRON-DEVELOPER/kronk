import 'package:flutter/material.dart';

class ProfileModeProvider extends ChangeNotifier {
  bool _isEditMode = false;

  bool get isEditMode => _isEditMode;

  void changeModel() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }
}
