import 'package:flutter/material.dart';

class MilestoneCircle extends StatelessWidget {
  final double percentage; // 0.0 to 100.0
  final int daysPassed;
  final int targetDays;
  final String title;

  const MilestoneCircle({
    super.key,
    required this.percentage,
    required this.daysPassed,
    required this.targetDays,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Convert percentage from 0-100 to 0-1 for CircularProgressIndicator
    final progressValue = (percentage / 100.0).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    color: const Color(0xFF4361EE),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${percentage.toInt()}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4361EE),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$daysPassed / $targetDays days',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
