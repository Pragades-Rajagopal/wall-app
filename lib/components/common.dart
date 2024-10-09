import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {duration = 3}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message.split('-').join(' ').toUpperCase(),
      ),
      duration: Duration(seconds: duration),
    ),
  );
}

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    ),
  );
}
