import 'package:flutter/material.dart';
import 'package:wall_app/components/icon_button.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final Function() onPressed;
  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(
        left: 20,
        right: 10,
        bottom: 20,
      ),
      margin: const EdgeInsets.only(
        left: 20,
        bottom: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              MyIconButton(
                onPressed: onPressed,
                icon: Icons.settings,
                color: Theme.of(context).colorScheme.secondary,
              )
            ],
          ),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.surfaceBright,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
