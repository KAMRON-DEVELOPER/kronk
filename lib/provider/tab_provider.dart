import 'package:flutter/material.dart';
import '../models/tab.dart';
import 'data_repository.dart';

class TabProvider extends ChangeNotifier {
  DataRepository dataRepository = DataRepository();
  List<MyTab?> tabs = [];

  TabProvider() {
    _loadTabs();
  }

  Future<void> _loadTabs() async {
    tabs = await dataRepository.getTabs();
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex--;
    }
    final MyTab? selectedTab = tabs.removeAt(oldIndex);
    tabs.insert(newIndex, selectedTab);
    notifyListeners();
    _saveTabs();
  }

  Future<void> _saveTabs() async {
    await dataRepository.setTabs(tabs);
  }
}
