class UserInfoModel {
  final String username;
  final String addictionType;
  final DateTime startDate;
  final int consumptionDayPerWeek;
  final int consumptionPerDay;
  final List<String> goals;
  final String mainMotivation; //prompted by user
  final String importanceForUser; // Critical, moderate...
  final String impliedPeople; // family, community, alone...
  final String firstMilestone;
  final DateTime dailyReview;

  UserInfoModel({
    required this.username,
    required this.addictionType,
    required this.startDate,
    required this.consumptionDayPerWeek,
    required this.consumptionPerDay,
    required this.goals,
    required this.mainMotivation,
    required this.importanceForUser,
    required this.impliedPeople,
    required this.firstMilestone,
    required this.dailyReview,
  });

  /// Convert object → Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'addictionType': addictionType,
      'startDate': startDate.toIso8601String(),
      'consumptionDayPerWeek': consumptionDayPerWeek,
      'consumptionPerDay': consumptionPerDay,
      'goals': goals,
      'mainMotivation': mainMotivation,
      'importanceForUser': importanceForUser,
      'impliedPeople': impliedPeople,
      'firstMilestone': firstMilestone,
      'dailyReview': dailyReview.toIso8601String(),
    };
  }

  /// Convert Map<String, dynamic> → object
  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      username: map['username'] ?? '',
      addictionType: map['addictionType'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      consumptionDayPerWeek: map['consumptionDayPerWeek']?.toInt() ?? 0,
      consumptionPerDay: map['consumptionPerDay']?.toInt() ?? 0,
      goals: List<String>.from(map['goals'] ?? []),
      mainMotivation: map['mainMotivation'] ?? '',
      importanceForUser: map['importanceForUser'] ?? '',
      impliedPeople: map['impliedPeople'] ?? '',
      firstMilestone: map['firstMilestone'] ?? '',
      dailyReview: DateTime.parse(map['dailyReview']),
    );
  }
}
