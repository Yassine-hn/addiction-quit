import 'package:flutter/material.dart';

class ProgressGrid extends StatelessWidget {
  final List<Map<String, dynamic>> dailySurveys;
  final int daysToShow;

  const ProgressGrid({
    super.key,
    required this.dailySurveys,
    this.daysToShow = 14,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Map of "YYYY-MM-DD" -> Survey
    final surveyMap = {
      for (var s in dailySurveys) (s['date'] as String).substring(0, 10): s
    };

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(daysToShow, (index) {
        // Generate from oldest to newest or newest to oldest?
        // "visual history of daily surveys ... days on x axisis"
        // Usually left is old, right is new.
        // So index 0 should be (Now - daysToShow + 1).
        
        // Wait, typical contribution graph (GitHub) is left-to-right, top-to-bottom.
        // Or strip is left-to-right.
        // Let's do (Now - (daysToShow - 1 - index)).
        // Example: daysToShow=3. i=0 -> Now-2. i=1 -> Now-1. i=2 -> Now.
        
        final date = now.subtract(Duration(days: daysToShow - 1 - index));
        final dateKey = date.toIso8601String().substring(0, 10);
        final survey = surveyMap[dateKey];
        
        Color boxColor;
        bool slipped = false;
        
        if (survey != null) {
          slipped = (survey['slipped'] as int? ?? 0) == 1;
        }

        // Logic:
        // Green: Survey done, didn't slip.
        // Red: Survey done, slipped.
        // Empty (Grey/Outline): Didn't slip (meaning didn't do survey, PER SPEC "empty if he didn't slip" which implies "missing record = didn't slip/didn't report").
        // Wait, "empty if he didn't slip" -- this is the ambiguous part.
        // "make it green if the user did his daily survey that day and didin't slip" -> Survey + !Slip = Green
        // "red if he did the survey at that day and slipped" -> Survey + Slip = Red
        // "empty if he didn't slip" -> likely means "Use empty box for no data/no slip reported".
        // What if no data but slipped? Impossible if no data.
        // So "No Data" = Empty Box.

        if (survey == null) {
          boxColor = Colors.transparent; // Border only
        } else if (slipped) {
          boxColor = Colors.red;
        } else {
          boxColor = Colors.green;
        }

        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: boxColor,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            "${date.day}",
             style: TextStyle(
               fontSize: 10, 
               color: survey == null ? Colors.grey : Colors.white
             )
          ),
        );
      }),
    );
  }
}
