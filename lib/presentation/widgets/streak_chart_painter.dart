import 'package:flutter/material.dart';
import 'dart:math';

class StreakChart extends StatelessWidget {
  final List<int> streakHistory;
  final double height;
  final Color lineColor;

  const StreakChart({
    super.key,
    required this.streakHistory,
    this.height = 200,
    this.lineColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    if (streakHistory.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: StreakChartPainter(
          data: streakHistory,
          lineColor: lineColor,
        ),
      ),
    );
  }
}

class StreakChartPainter extends CustomPainter {
  final List<int> data;
  final Color lineColor;

  StreakChartPainter({
    required this.data,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Find min and max for scaling
    int maxY = data.reduce(max);
    if (maxY == 0) maxY = 1; // Avoid division by zero
    
    final double stepX = size.width / (data.length - 1);
    
    // Draw line
    for (int i = 0; i < data.length; i++) {
        final double x = i * stepX;
        final double normalizedY = data[i] / maxY;
        final double y = size.height - (normalizedY * size.height); // Invert Y because 0 is top
        
        if (i == 0) {
            path.moveTo(x, y);
        } else {
            path.lineTo(x, y);
        }
        
        // Draw points
        canvas.drawCircle(Offset(x, y), 3.0, Paint()..color = lineColor);
    }
    
    canvas.drawPath(path, paint);
    
    // Optional: Draw guidelines or text? User asked for "chart... x line... y line".
    // Keeping it simple as "a line that connect the following points"
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
