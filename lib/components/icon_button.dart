import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final Color color;
  final double iconSize;
  const MyIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.color,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
      ),
      iconSize: iconSize,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
