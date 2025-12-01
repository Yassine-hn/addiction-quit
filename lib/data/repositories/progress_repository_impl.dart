// repositories/progress_repository_impl.dart
import 'package:flutter/material.dart';
import '../models/progress_data.dart';
import 'progress_repository.dart';



class ProgressRepositoryImpl implements ProgressRepository {
  @override
  Future<ProgressData> getProgressData() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return ProgressData(
      percentage: 75.0,
      daysStreak: '30',
    );
  }

  @override
  Future<WeeklyProgress> getWeeklyProgress() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return WeeklyProgress(
      changePercentage: '+5%',
      days: [
        DayProgress(day: 'MON', value: 80, color: Colors.green),
        DayProgress(day: 'TUE', value: 50, color: Colors.yellow),
        DayProgress(day: 'WED', value: 65, color: Colors.green),
        DayProgress(day: 'THU', value: 90, color: Colors.orange),
        DayProgress(day: 'FRI', value: 100, color: Colors.red),
        DayProgress(day: 'SAT', value: 75, color: Colors.green),
        DayProgress(day: 'SUN', value: 85, color: Colors.orange),
      ],
    );
  }

  @override
  Future<List<Goal>> getAvailableGoals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Goal(title: 'No Alcohol', icon: Icons.no_drinks, isSelected: true),
      Goal(title: 'Quit Smoking', icon: Icons.smoke_free, isSelected: false),
      Goal(title: 'Mindful Social\nMedia', icon: Icons.hourglass_empty, isSelected: false),
      Goal(title: 'Reduce Caffeine', icon: Icons.coffee, isSelected: false),
    ];
  }

  @override
  Future<void> selectGoal(String goalTitle) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Update selected goal in backend/database
  }
}