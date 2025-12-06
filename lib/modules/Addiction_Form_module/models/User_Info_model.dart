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
  final DateTime? dailyReview;

  /// New field
  final Map<String, dynamic>? moneySavedPerDay;

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
    this.dailyReview,
    this.moneySavedPerDay,
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
    DateTime? dailyReview,
    Map<String, dynamic>? moneySavedPerDay,
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
      dailyReview: dailyReview ?? this.dailyReview,
      moneySavedPerDay: moneySavedPerDay ?? this.moneySavedPerDay,
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
      'dailyReview': dailyReview?.toIso8601String(),

      /// Map saved as-is
      'moneySavedPerDay': moneySavedPerDay,
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
      dailyReview: map['dailyReview'] != null
          ? DateTime.parse(map['dailyReview'])
          : null,

      /// Read map
      moneySavedPerDay: map['moneySavedPerDay'] != null
          ? Map<String, dynamic>.from(map['moneySavedPerDay'])
          : null,
    );
  }

  /// Debug print method
  void debugPrint() {
    print('''
==== UserInfoModel ====
username: $username
addictionType: $addictionType
startDate: $startDate
consumptionDayPerWeek: $consumptionDayPerWeek
consumptionPerDay: $consumptionPerDay
goals: $goals
mainMotivation: $mainMotivation
importanceForUser: $importanceForUser
impliedPeople: $impliedPeople
dailyReview: $dailyReview
moneySavedPerDay: $moneySavedPerDay
========================
''');
  }

  @override
  String toString() {
    return '''
UserInfoModel(
  username: $username,
  addictionType: $addictionType,
  startDate: $startDate,
  consumptionDayPerWeek: $consumptionDayPerWeek,
  consumptionPerDay: $consumptionPerDay,
  goals: $goals,
  mainMotivation: $mainMotivation,
  importanceForUser: $importanceForUser,
  impliedPeople: $impliedPeople,
  dailyReview: $dailyReview,
  moneySavedPerDay: $moneySavedPerDay,
)''';
  }
}
