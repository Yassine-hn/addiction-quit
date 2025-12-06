// First, let's create a reusable MultiSelectChip component
import 'package:flutter/material.dart';

class MultiSelectChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;

  const MultiSelectChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 8, bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 0, 9, 180)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color.fromARGB(255, 0, 9, 180)
                    : const Color(0xFFDDDDDD),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          0,
                          9,
                          180,
                        ).withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.add_circle_outline,
                  size: 18,
                  color: isSelected ? Colors.white : const Color(0xFF999999),
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
