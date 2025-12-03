import 'package:flutter/material.dart';

class ValidationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ValidationButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95, // 🔥 largeur réduite
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 9, 180),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, //
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
