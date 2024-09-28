import 'package:flutter/material.dart';

showTopSnackBar({context, message, backgroundColor, duration}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      height: 56,
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ),
    padding: const EdgeInsets.only(left: 12, right: 12),
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 256,
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    duration: duration ?? const Duration(milliseconds: 1000),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    dismissDirection: DismissDirection.up,
  ));
}
