// Updated ValidationButton.dart
import 'package:flutter/material.dart';

class ValidationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final bool fullWidth;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;

  const ValidationButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.fullWidth = true,
    this.height = 56,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBgColor = const Color.fromARGB(255, 0, 9, 180);
    final defaultTextColor = Colors.white;

    final button = ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled
            ? (backgroundColor ?? defaultBgColor)
            : Colors.grey[300],
        foregroundColor: enabled
            ? (textColor ?? defaultTextColor)
            : Colors.grey[500],
        minimumSize: Size(fullWidth ? double.infinity : 0, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
