class UserInfoModel {
  final String? username;
  final String? addictionType;
  final DateTime? startDate;
  final int? consumptionDayPerWeek;
  final int? consumptionPerDay;
  final List<String>? goals;
  final String? mainMotivation;
  final String? importanceForUser;
  final String? impliedPeople;
  final String? firstMilestone;
  final DateTime? dailyReview;

  const UserInfoModel({
    this.username,
    this.addictionType,
    this.startDate,
    this.consumptionDayPerWeek,
    this.consumptionPerDay,
    this.goals,
    this.mainMotivation,
    this.importanceForUser,
    this.impliedPeople,
    this.firstMilestone,
    this.dailyReview,
  });

  UserInfoModel copyWith({
    String? username,
    String? addictionType,
    DateTime? startDate,
    int? consumptionDayPerWeek,
    int? consumptionPerDay,
    List<String>? goals,
    String? mainMotivation,
    String? importanceForUser,
    String? impliedPeople,
    String? firstMilestone,
    DateTime? dailyReview,
  }) {
    return UserInfoModel(
      username: username ?? this.username,
      addictionType: addictionType ?? this.addictionType,
      startDate: startDate ?? this.startDate,
      consumptionDayPerWeek:
          consumptionDayPerWeek ?? this.consumptionDayPerWeek,
      consumptionPerDay: consumptionPerDay ?? this.consumptionPerDay,
      goals: goals ?? this.goals,
      mainMotivation: mainMotivation ?? this.mainMotivation,
      importanceForUser: importanceForUser ?? this.importanceForUser,
      impliedPeople: impliedPeople ?? this.impliedPeople,
      firstMilestone: firstMilestone ?? this.firstMilestone,
      dailyReview: dailyReview ?? this.dailyReview,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'addictionType': addictionType,
      'startDate': startDate?.toIso8601String(),
      'consumptionDayPerWeek': consumptionDayPerWeek,
      'consumptionPerDay': consumptionPerDay,
      'goals': goals,
      'mainMotivation': mainMotivation,
      'importanceForUser': importanceForUser,
      'impliedPeople': impliedPeople,
      'firstMilestone': firstMilestone,
      'dailyReview': dailyReview?.toIso8601String(),
    };
  }

  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      username: map['username'],
      addictionType: map['addictionType'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      consumptionDayPerWeek: map['consumptionDayPerWeek'],
      consumptionPerDay: map['consumptionPerDay'],
      goals: map['goals'] != null ? List<String>.from(map['goals']) : null,
      mainMotivation: map['mainMotivation'],
      importanceForUser: map['importanceForUser'],
      impliedPeople: map['impliedPeople'],
      firstMilestone: map['firstMilestone'],
      dailyReview: map['dailyReview'] != null
          ? DateTime.parse(map['dailyReview'])
          : null,
    );
  }
}
