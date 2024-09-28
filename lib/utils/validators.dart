import 'package:flutter/material.dart';

extension ValidatorExtension on String {
  String? get isValidName {
    final nameRegExp = RegExp(r"^[A-Za-z][A-Za-z0-9_]{4,19}$");
    if (isEmpty) {
      return "Please fill the username field";
    } else if (!nameRegExp.hasMatch(this)) {
      return "Username is incorrect";
    }
    return null;
  }

  String? get isValidPassword {
    final passwordRegExp = RegExp(
        r'^(?!.*(?:012|123|234|345|456|567|678|789|890))(?=.*[A-Za-z0-9]).{6,20}$');
    if (isEmpty) {
      return "Please fill the password field";
    } else if (!passwordRegExp.hasMatch(this)) {
      return "Password is incorrect";
    }
    return null;
  }

  String? get isValidEmailOrPhone {
    final regex = RegExp(
      r"^((?=.{10,13})^\+?[0-9]+$)|"
      r"^([a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+)$",
    );

    if (!regex.hasMatch(this)) {
      if (startsWith('+')) {
        return "Phone number is incorrect";
      } else if (startsWith(RegExp(r'^[a-zA-Z0-9]'))) {
        return "Email is incorrect";
      } else {
        return "Please enter a phone number or email";
      }
    }
    return null;
  }

  String? get isValidCode {
    if (isEmpty) {
      return "Please, fill the code field";
    } else if (length < 4) {
      return "Too short, code should contains 4 digit";
    } else if (length > 4) {
      return "Too long, code should contains 4 digit";
    } else {
      return null;
    }
  }
}

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }

  double doubleCacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).floorToDouble();
  }
}

extension ColorExtention on String {
  Color fromHex() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
