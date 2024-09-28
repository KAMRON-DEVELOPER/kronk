import 'package:flutter/material.dart';

class SelectedNoteProvider extends ChangeNotifier {
  final List<int> _selectedIndexes = [];

  List<int> get selectedIndexes => _selectedIndexes;

  void toggleSelection(int index) {
    // print('toggleSelection >> $index');
    // print('_selectedIndexes >> $_selectedIndexes');
    if (_selectedIndexes.contains(index)) {
      _selectedIndexes.remove(index);
    } else {
      _selectedIndexes.add(index);
      print('selectedIndex: $_selectedIndexes');
    }
    notifyListeners();
  }
}
