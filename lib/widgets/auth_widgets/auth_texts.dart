import 'package:flutter/material.dart';

Widget buildRegisterText() {
  return const Column(
    children: [
      Text(
        'Create an account',
        style: TextStyle(color: Colors.white, fontSize: 36),
      ),
      SizedBox(height: 16),
      Text(
        'Please enter your username, password, and either your email or phone number to register.',
        style: TextStyle(color: Colors.white24, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget buildLoginText() {
  return const Column(
    children: [
      Text(
        'Login',
        style: TextStyle(color: Colors.white, fontSize: 48),
      ),
      SizedBox(height: 8),
      Text(
        'Almost there! Please enter your username and password to continue.',
        style: TextStyle(color: Colors.white24, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget buildResetPassword({required void Function() onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      GestureDetector(
        onTap: onTap,
        child: const Text(
          'Reset password',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.green,
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}

Widget buildAlreadyHaveAccount({required void Function() onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Already have an account?",
        style: TextStyle(
          color: Colors.white24,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(width: 12),
      GestureDetector(
        onTap: onTap,
        child: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.green,
            fontSize: 16,
          ),
        ),
      )
    ],
  );
}

Widget buildDontHaveAccount({required void Function() onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Don't have an account?",
        style: TextStyle(
          color: Colors.white24,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(width: 12),
      GestureDetector(
        onTap: onTap,
        child: const Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.green,
            fontSize: 16,
          ),
        ),
      )
    ],
  );
}

Widget buildOrContinueWith() {
  return const Row(
    children: [
      Expanded(
        child: Divider(thickness: 1, color: Colors.white24),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          'or continue with',
          style: TextStyle(
            color: Colors.white24,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      Expanded(
        child: Divider(thickness: 1, color: Colors.white24),
      ),
    ],
  );
}
