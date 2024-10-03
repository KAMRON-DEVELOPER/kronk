import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/authentication/authentication_state.dart';

Widget buildAuthButton({
  required BuildContext context,
  required AuthenticationState authState,
  required String? usernameError,
  required String? emailOrPhoneError,
  required String? passwordError,
  required TextEditingController usernameController,
  TextEditingController? emailOrPhoneController,
  required TextEditingController passwordController,
  required void Function() onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      child: authState == AuthenticationLoading()
          ? const Text(
              "Loading...",
              style: TextStyle(
                color: Colors.black,
              ),
            )
          : Text(
              emailOrPhoneController == null ? "Login" : "Register",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
    ),
  );
}

Widget buildContinueWithRegisterButtons({required void Function() onTap}) {
  return ElevatedButton(
      onPressed: onTap,
      child: const Text(
        'Register',
        style: TextStyle(color: Colors.white),
      ));
}

Widget buildSocialButtons({
  required double socialAuthIconSize,
  required String googleIconPath,
  required String twitterxIconPath,
  required String linkedinIconPath,
  required String githubIconPath,
  required void Function() onTapOnGoogle,
  required void Function() onTapOnTwitterx,
  required void Function() onTapOnLinkedIn,
  required void Function() onTapOnGithub,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: onTapOnGoogle,
        child: SvgPicture.asset(
          googleIconPath,
          width: socialAuthIconSize,
          height: socialAuthIconSize,
        ),
      ),
      GestureDetector(
        onTap: onTapOnTwitterx,
        child: SvgPicture.asset(
          twitterxIconPath,
          width: socialAuthIconSize,
          height: socialAuthIconSize,
        ),
      ),
      GestureDetector(
        onTap: onTapOnLinkedIn,
        child: SvgPicture.asset(
          linkedinIconPath,
          width: socialAuthIconSize,
          height: socialAuthIconSize,
        ),
      ),
      GestureDetector(
        onTap: onTapOnGithub,
        child: SvgPicture.asset(
          githubIconPath,
          width: socialAuthIconSize,
          height: socialAuthIconSize,
        ),
      ),
    ],
  );
}
