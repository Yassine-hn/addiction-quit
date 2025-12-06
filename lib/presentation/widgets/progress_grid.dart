import 'package:flutter/material.dart';

class ProgressGrid extends StatelessWidget {
  final List<Map<String, dynamic>> dailySurveys;
  final int daysToShow;

  const ProgressGrid({
    super.key,
    required this.dailySurveys,
    this.daysToShow = 30,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Map of "YYYY-MM-DD" -> Survey
    final surveyMap = {
      for (var s in dailySurveys) (s['date'] as String).substring(0, 10): s,
    };

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Survey History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: List.generate(daysToShow, (index) {
                final date = now.subtract(
                  Duration(days: daysToShow - 1 - index),
                );
                final dateKey = date.toIso8601String().substring(0, 10);
                final survey = surveyMap[dateKey];

                Color boxColor;
                bool slipped = false;

                if (survey != null) {
                  // Check both 'slip' (bool) and 'slipped' (int) for compatibility
                  if (survey.containsKey('slip')) {
                    slipped = survey['slip'] as bool? ?? false;
                  } else {
                    slipped = (survey['slipped'] as int? ?? 0) == 1;
                  }
                }

                // Logic:
                // GREEN: Daily survey exists AND slip = false
                // RED: Daily survey exists AND slip = true
                // GRAY/EMPTY: No daily survey record for that date

                if (survey == null) {
                  boxColor = Colors.grey.shade300; // Gray for no survey
                } else if (slipped) {
                  boxColor = const Color(0xFFF72585); // Red for slip
                } else {
                  boxColor = const Color(0xFF4CC9F0); // Green for no slip
                }

                return Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: boxColor,
                    border: Border.all(
                      color: survey == null
                          ? Colors.grey.shade400
                          : Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(const Color(0xFF4CC9F0), 'No Slip'),
                _buildLegendItem(const Color(0xFFF72585), 'Slipped'),
                _buildLegendItem(Colors.grey.shade300, 'No Survey'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
