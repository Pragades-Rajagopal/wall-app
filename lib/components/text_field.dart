import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        fillColor: Theme.of(context).colorScheme.primary,
        filled: true,
        focusColor: Theme.of(context).colorScheme.surfaceBright,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      cursorColor: Theme.of(context).colorScheme.surfaceBright,
    );
  }
}
