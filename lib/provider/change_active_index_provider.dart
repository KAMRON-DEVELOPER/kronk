import 'package:flutter/material.dart';

class ActiveIndexProvider extends ChangeNotifier {
  int _activeIndex = 0;

  int get activeIndex => _activeIndex;

  void changeActiveIndex(int index) {
    // print('1) toggleSettings is starting, _activeIndex = $_activeIndex!!!');
    _activeIndex = index;
    // print('2) toggleSettings is ending, _activeIndex = $_activeIndex!!!');
    notifyListeners();
  }
}
