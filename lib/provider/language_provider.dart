import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LanguageProvider extends ChangeNotifier {
  late String _currentLanguage;

  LanguageProvider() {
    _currentLanguage =
        Hive.box('settingsBox').get('language', defaultValue: "english");
  }

  String get currentLanguage => _currentLanguage;

  Future<void> switchLanguage(String language) async {
    print('previous language: $_currentLanguage');
    _currentLanguage = language;
    await Hive.box('settingsBox').put('language', language);
    print('new language: $_currentLanguage');
    notifyListeners();
  }
}
