// New FrequencyOption.dart - Reusable option component
import 'package:flutter/material.dart';

class FrequencyOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isIrregular;

  const FrequencyOption({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isIrregular = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 0, 9, 180)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 0, 9, 180)
                : const Color(0xFFEEEEEE),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      0,
                      9,
                      180,
                    ).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: isIrregular
                  ? const EdgeInsets.symmetric(vertical: 16, horizontal: 24)
                  : const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: isIrregular ? 18 : 24,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
