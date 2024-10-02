import 'package:flutter/material.dart';

Widget buildAuthInputField({
  required String labelText,
  required TextEditingController controller,
  required String? errorText,
  required void Function(String) onChanged,
}) {
  return TextFormField(
    onChanged: onChanged,
    controller: controller,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: labelText,
      errorText: errorText,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(15),
      ),
      hintStyle: const TextStyle(color: Colors.white),
      counterStyle: const TextStyle(color: Colors.white),
    ),
  );
}
