// Updated ValidationButton.dart - Now more flexible
import 'package:flutter/material.dart';

class ValidationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final bool fullWidth;
  final double height;
  final Color? backgroundColor;

  const ValidationButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.fullWidth = true,
    this.height = 56,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled
            ? (backgroundColor ?? const Color.fromARGB(255, 0, 9, 180))
            : Colors.grey[300],
        foregroundColor: enabled ? Colors.white : Colors.grey[500],
        minimumSize: Size(fullWidth ? double.infinity : 0, height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
