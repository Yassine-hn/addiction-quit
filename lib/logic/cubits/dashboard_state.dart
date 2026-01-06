import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardEmpty extends DashboardState {
  final String message;
  const DashboardEmpty({
    this.message = 'No active addictions found. Start one!',
  });

  @override
  List<Object?> get props => [message];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardLoaded extends DashboardState {
  final int selectedAddictionId;
  final List<Map<String, dynamic>> allAddictions;

  // Milestone Data
  final Map<String, dynamic> milestoneData;
  final double milestonePercentage;

  // Progress Grid Data (Raw list of surveys for last X days)
  final List<Map<String, dynamic>> dailySurveys;

  // Streak Chart Data (changed to Map format)
  final List<Map<String, dynamic>> streakHistory;

  // Additional info for UI
  final String addictionName;
  final String moodEmoji; // Static for now as requested

  const DashboardLoaded({
    required this.selectedAddictionId,
    required this.allAddictions,
    required this.milestoneData,
    required this.milestonePercentage,
    required this.dailySurveys,
    required this.streakHistory, // Now List<Map<String, dynamic>>
    required this.addictionName,
    this.moodEmoji = '🙂',
  });

  @override
  List<Object?> get props => [
    selectedAddictionId,
    allAddictions,
    milestoneData,
    milestonePercentage,
    dailySurveys,
    streakHistory,
    addictionName,
    moodEmoji,
  ];

  DashboardLoaded copyWith({
    int? selectedAddictionId,
    List<Map<String, dynamic>>? allAddictions,
    Map<String, dynamic>? milestoneData,
    double? milestonePercentage,
    List<Map<String, dynamic>>? dailySurveys,
    List<Map<String, dynamic>>? streakHistory,
    String? addictionName,
    String? moodEmoji,
  }) {
    return DashboardLoaded(
      selectedAddictionId: selectedAddictionId ?? this.selectedAddictionId,
      allAddictions: allAddictions ?? this.allAddictions,
      milestoneData: milestoneData ?? this.milestoneData,
      milestonePercentage: milestonePercentage ?? this.milestonePercentage,
      dailySurveys: dailySurveys ?? this.dailySurveys,
      streakHistory: streakHistory ?? this.streakHistory,
      addictionName: addictionName ?? this.addictionName,
      moodEmoji: moodEmoji ?? this.moodEmoji,
    );
  }
}
