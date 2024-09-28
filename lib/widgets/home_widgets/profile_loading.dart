import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../bloc/profile/profile_state.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';


Column buildProfileLoading(ProfileStateLoading state, BuildContext context, lottieController) {
  final theme = Provider.of<ThemeProvider>(context).currentTheme;
  final screenWidth = MediaQuery.of(context).size.width;
  // final screenHeight = MediaQuery.of(context).size.height;

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: screenWidth * 0.9,
        height: screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: theme.activeTabColor.withOpacity(0.2),
        ),
        child: Lottie.asset(
          "assets/animations/wave-circle.json",
          width: 200,
          height: 200,
          alignment: Alignment.center,
          controller: lottieController,
        ),
      ),
    ],
  );
}
