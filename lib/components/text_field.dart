import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
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
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool autoEdit = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => setState(() => autoEdit = true),
      child: TextField(
        controller: widget.controller,
        enabled: autoEdit,
        onTapOutside: (_) => setState(() => autoEdit = false),
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
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
      ),
    );
  }
}
