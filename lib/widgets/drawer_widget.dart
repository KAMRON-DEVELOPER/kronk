import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import 'appbar.dart';
import 'navbar.dart';
import 'tabbar.dart';

Widget buildDrawerWidget({
  required BuildContext context,
  required String appBarTitle,
  required Widget body,
}) {
  final theme = Provider.of<ThemeProvider>(context).currentTheme;

  return Scaffold(
    backgroundColor: theme.background2,
    appBar: buildAppBar(context, appBarTitle),
    body: Column(
      children: [
        const CustomTabBar(),
        Expanded(
          child: body,
        ),
      ],
    ),
    bottomNavigationBar: const Navbar(),
  );
}
