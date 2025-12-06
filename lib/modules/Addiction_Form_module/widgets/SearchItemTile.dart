import 'package:flutter/material.dart';

class SearchItemTile extends StatelessWidget {
  final String text;
  final bool selected;
  final bool hasBorder;
  final VoidCallback onTap;

  const SearchItemTile({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
    required this.hasBorder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: hasBorder
              ? const Border(top: BorderSide(color: Colors.black12, width: 1))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 17)),
            selected
                ? const Icon(
                    Icons.check_circle,
                    color: Color.fromARGB(255, 139, 145, 255), // 🔥
                  )
                : const Icon(Icons.circle_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
