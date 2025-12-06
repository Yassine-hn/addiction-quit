import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'dart:math';

class StreakChart extends StatelessWidget {
  final List<Map<String, dynamic>> streakHistory; // Changed to Map format
  final double height;
  final Color lineColor;

  const StreakChart({
    super.key,
    required this.streakHistory,
    this.height = 200,
    this.lineColor = const Color(0xFF4361EE),
  });

  @override
  Widget build(BuildContext context) {
    if (streakHistory.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: height,
            child: Center(
              child: Text(AppLocalizations.of(context)!.noStreakDataAvailable),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.streakChart,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: height,
              width: double.infinity,
              child: CustomPaint(
                painter: StreakChartPainter(
                  data: streakHistory,
                  lineColor: lineColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreakChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Color lineColor;

  StreakChartPainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Extract streak values from maps
    final streakValues = data
        .map((d) => d['streak_value'] as int? ?? 0)
        .toList();

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final path = Path();

    // Find min and max for scaling
    int maxY = streakValues.reduce(max);
    int minY = streakValues.reduce(min);
    if (maxY == minY) {
      maxY = minY + 1; // Avoid division by zero
    }

    final double stepX = data.length > 1 ? size.width / (data.length - 1) : 0;
    final double rangeY = (maxY - minY).toDouble();

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw Y-axis labels and grid
    for (int i = 0; i <= 4; i++) {
      final yValue = minY + (rangeY * i / 4);
      final y = size.height - ((yValue - minY) / rangeY * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw line and points
    for (int i = 0; i < streakValues.length; i++) {
      final double x = i * stepX;
      final double normalizedY = rangeY > 0
          ? (streakValues[i] - minY) / rangeY
          : 0.5;
      final double y = size.height - (normalizedY * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw points
      canvas.drawCircle(Offset(x, y), 4.0, pointPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
