import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    required this.title,
    required this.isOn,
    required this.onPressed,
    super.key,
  });

  final String title;
  final bool isOn;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        isOn ? '$title ✅️' : '$title ⬜️',
      ),
    );
  }
}
