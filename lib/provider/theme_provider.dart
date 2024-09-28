import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../widgets/custom_theme.dart';

class ThemeProvider extends ChangeNotifier {
  late MyTheme _currentTheme;

  ThemeProvider() {
    final themeName = Hive.box('settingsBox').get('theme', defaultValue: 'blue');
    _currentTheme = (CustomTheme.themes[themeName] ?? CustomTheme.themes['blue'])!;
  }

  MyTheme get currentTheme => _currentTheme;

  Future<void> changeTheme(String theme) async {
    _currentTheme = (CustomTheme.themes[theme] ?? CustomTheme.themes['blue']) as MyTheme;
    await Hive.box('settingsBox').put('theme', theme);
    notifyListeners();
  }
}
