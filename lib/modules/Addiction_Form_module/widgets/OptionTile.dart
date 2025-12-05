// OptionTile.dart
import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const OptionTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8E8FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color.fromARGB(255, 0, 9, 180)
                  : const Color(0xFFEEEEEE),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? const Color.fromARGB(255, 0, 9, 180)
                        : Colors.black87,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
              if (isSelected && trailing == null)
                const Icon(
                  Icons.check_circle,
                  color: Color.fromARGB(255, 0, 9, 180),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
