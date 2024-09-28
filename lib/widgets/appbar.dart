import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

enum Options { search, upload, copy, exit }

AppBar buildAppBar(BuildContext context, String title) {
  final theme = Provider.of<ThemeProvider>(context).currentTheme;
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  // print("screenWidth: $screenWidth");
  // print("screenHeight: $screenHeight");
  return AppBar(
    backgroundColor: theme.background1,
    toolbarHeight: screenHeight/15,
    title: Text(
      "NQE",
      style: GoogleFonts.alegreya(
        color: theme.activeTabColor,
        fontSize: screenHeight/25,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      Container(
        width: screenWidth/2,
        height: screenHeight/25,
        color: Colors.blue.withOpacity(0.1),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: theme.activeTabColor),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.activeTabColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.activeTabColor),
            ),
            hintText: "search",
            hintStyle: TextStyle(color: theme.activeTabColor),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: CircleAvatar(
          backgroundColor: theme.background1,
          radius: screenHeight/50,
          child: Icon(Iconsax.user, color: theme.activeTabColor),
        ),
      )
    ],
  );
}
