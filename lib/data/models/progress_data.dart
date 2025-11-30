// models/progress_data.dart
import 'package:flutter/material.dart';


class ProgressData {
  final double percentage;
  final String daysStreak;

  ProgressData({
    required this.percentage,
    required this.daysStreak,
  });
}

class WeeklyProgress {
  final List<DayProgress> days;
  final String changePercentage;

  WeeklyProgress({
    required this.days,
    required this.changePercentage,
  });
}

class DayProgress {
  final String day;
  final double value;
  final Color color;

  DayProgress({
    required this.day,
    required this.value,
    required this.color,
  });
}

class Goal {
  final String title;
  final IconData icon;
  final bool isSelected;

  Goal({
    required this.title,
    required this.icon,
    required this.isSelected,
  });
}

