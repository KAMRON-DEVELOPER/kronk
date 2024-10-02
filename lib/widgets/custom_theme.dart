import 'package:flutter/material.dart';


class CustomTheme {
  static final Map<String, MyTheme> themes = {
    'dark': MyTheme(
      background1: BlueColors.background1,
      background2: BlueColors.background2,
      background3: BlueColors.background3,
      background4: BlueColors.background4,
      text1: BlueColors.text1,
      text2: BlueColors.text2,
      tabColor: BlueColors.tabColor,
      activeTabColor: BlueColors.activeTabColor,
    ),
    'white': MyTheme(
      background1: WhiteColors.background1,
      background2: WhiteColors.background2,
      background3: WhiteColors.background3,
      background4: WhiteColors.background4,
      text1: WhiteColors.text1,
      text2: WhiteColors.text2,
      tabColor: WhiteColors.tabColor,
      activeTabColor: WhiteColors.activeTabColor,
    ),
    'green': MyTheme(
      background1: GreenColors.background1,
      background2: GreenColors.background2,
      background3: GreenColors.background3,
      background4: GreenColors.background4,
      text1: GreenColors.text1,
      text2: GreenColors.text2,
      tabColor: GreenColors.tabColor,
      activeTabColor: GreenColors.activeTabColor,
      // Add more properties as needed
    ),
    'yellow': MyTheme(
      background1: YellowColors.background1,
      background2: YellowColors.background2,
      background3: YellowColors.background3,
      background4: YellowColors.background4,
      text1: YellowColors.text1,
      text2: YellowColors.text2,
      tabColor: YellowColors.tabColor,
      activeTabColor: YellowColors.activeTabColor,
    ),
  };
}


class MyTheme {
  final Color background1;
  final Color background2;
  final Color background3;
  final Color background4;
  final Color text1;
  final Color text2;
  final Color tabColor;
  final Color activeTabColor;

  MyTheme({
    required this.background1,
    required this.background2,
    required this.background3,
    required this.background4,
    required this.text1,
    required this.text2,
    required this.tabColor,
    required this.activeTabColor,
  });
}

class WhiteColors {
  static const Color background1 = Color(0xFF1f2128);
  static const Color background2 = Color(0xFF302552);
  static const Color background3 = Color(0xFF443564);
  static const Color background4 = Color(0xFF7737ff);
  static const Color text1 = Color(0xFFFFFFFF);
  static const Color text2 = Color(0xFF7737ff);
  static const Color tabColor = Color(0xff4c4370);
  static const Color activeTabColor = Color(0xFF7737ff);
  static const Color divider = Color(0xff6E45FE);
}

class BlueColors {
  static const Color background1 = Color(0xFF181a25);
  static const Color background2 = Color(0xFF0e1118);
  static const Color background3 = Color(0xFF4a6075);
  static const Color background4 = Color(0xFF9fb8e0);
  static const Color text1 = Color(0xFFFFFFFF);
  static const Color text2 = Color(0xff9fb8e0);
  static const Color tabColor = Color(0xff4489ff);
  static const Color activeTabColor = Color(0xff4489ff);
  static const Color divider = Color(0xff6E45FE);
}

class GreenColors {
  static const Color background1 = Color(0xFF1b1e22);
  static const Color background2 = Color(0xFF24292d);
  static const Color background3 = Color(0xFF00b14e);
  static const Color background4 = Color(0xFF9fb8e0);
  static const Color text1 = Color(0xFFffffff);
  static const Color text2 = Color(0xFF6E45FE);
  static const Color tabColor = Color(0xff5fb091);
  static const Color activeTabColor = Color(0xff1effa9);
  static const Color divider = Color(0xFFBDBDBD);
}

class YellowColors {
  static const Color background1 = Color(0xFF000000);
  static const Color background2 = Color(0xFF212121);
  static const Color background3 = Color(0xFF6E45FE);
  static const Color background4 = Color(0xFF9fb8e0);
  static const Color text1 = Color(0xFFFFFFFF);
  static const Color text2 = Color(0xFFffffff);
  static const Color tabColor = Color(0xffffcc80);
  static const Color activeTabColor = Color(0xffffa726);
  static const Color divider = Color(0xff6E45FE);
}
