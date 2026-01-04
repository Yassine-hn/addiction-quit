// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Addiction Quit App';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get community => 'Community';

  @override
  String get welcomeAboard => 'Welcome Aboard!';

  @override
  String get welcomeMessage =>
      'You\'ve taken the first and most important\nstep. We\'re here to support you on your\npath to a healthier life.';

  @override
  String get noActiveMilestone => 'No Active Milestone';

  @override
  String get startNewMilestone => 'Start New Milestone';

  @override
  String get startMyJourney => 'Start My Journey';

  @override
  String get selectMilestone => 'Select Milestone';

  @override
  String get cancel => 'Cancel';

  @override
  String milestoneStarted(String title) {
    return '$title started!';
  }

  @override
  String get oneDayMilestone => '1 Day Milestone';

  @override
  String get oneWeekMilestone => '1 Week Milestone';

  @override
  String get twoWeeksMilestone => '2 Weeks Milestone';

  @override
  String get oneMonthMilestone => '1 Month Milestone';

  @override
  String get twoMonthsMilestone => '2 Months Milestone';

  @override
  String get threeMonthsMilestone => '3 Months Milestone';

  @override
  String get sixMonthsMilestone => '6 Months Milestone';

  @override
  String get oneYearMilestone => '1 Year Milestone';

  @override
  String daysMilestone(int days) {
    return '$days Days Milestone';
  }

  @override
  String get dailySurveyHistory => 'Daily Survey History';

  @override
  String get streakChart => 'Streak Chart';

  @override
  String get moodTracker => 'Mood Tracker';

  @override
  String get moodTrackingComingSoon => 'Mood tracking coming soon';

  @override
  String get noAddictionsFound => 'No addictions found';

  @override
  String get yourAddictions => 'Your Addictions';

  @override
  String started(String date) {
    return 'Started: $date';
  }

  @override
  String get noSlip => 'No Slip';

  @override
  String get slipped => 'Slipped';

  @override
  String get noSurvey => 'No Survey';

  @override
  String get noStreakDataAvailable => 'No streak data available';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get noAddictionsFoundCreateOne =>
      'No addictions found. Create one to start!';

  @override
  String get noActiveAddictionsFound =>
      'No active addictions found. Start one!';

  @override
  String get failedToLoadDashboard => 'Failed to load dashboard';

  @override
  String get noUserIDFound => 'No user ID found. Please login.';

  @override
  String get unableToCreateMilestone => 'Unable to create milestone';

  @override
  String errorCreatingMilestone(String error) {
    return 'Error creating milestone: $error';
  }

  @override
  String get youAreSoberFor => 'You are sober for';

  @override
  String get days => 'DAYS';

  @override
  String get hours => 'HOURS';

  @override
  String get minutes => 'MIN';

  @override
  String get streak => 'Streak';

  @override
  String get timeSaved => 'Time\nSaved';

  @override
  String get moneySaved => 'Money\nSaved';

  @override
  String get daysUnit => 'days';

  @override
  String get yourDailyCheckIn => 'Your Daily Check-in';

  @override
  String get myMood => 'My Mood';

  @override
  String get awful => 'Awful';

  @override
  String get sad => 'Sad';

  @override
  String get okay => 'Okay';

  @override
  String get good => 'Good';

  @override
  String get cravingLevel => 'Craving Level';

  @override
  String get low => 'Low';

  @override
  String get high => 'High';

  @override
  String get todayJournalOptional => 'Today\'s Journal (Optional)';

  @override
  String get writeAboutYourDay => 'Write about your day...';

  @override
  String get completeCheckIn => 'Complete Check-in';

  @override
  String get checkInCompleted => 'Check-In Completed!';

  @override
  String get greatJobStayingOnTrack => 'Great job staying on track today!';

  @override
  String get checkInAgain => 'Check In Again';

  @override
  String get pleaseSelectMoodAndCraving =>
      'Please select mood and craving level';

  @override
  String get failedToSubmitCheckIn => 'Failed to submit check-in';

  @override
  String get dailyQuote => 'Daily Quote';

  @override
  String get previousAchievements => 'Previous Achievements';

  @override
  String get myJourney => 'My Journey';

  @override
  String currentStreak(int streak) {
    return 'Current Streak: $streak days';
  }

  @override
  String get timeSober => 'Time Sober';

  @override
  String daysDays(int days) {
    return '$days Days';
  }

  @override
  String get newAddiction => 'New Addiction';

  @override
  String get startTrackingNewAddiction => 'Start tracking a new addiction';

  @override
  String awardedOn(String date) {
    return 'Awarded on $date';
  }

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get helloUser => 'Hello, User';

  @override
  String duplicateAddictionError(String type) {
    return 'An active addiction of type \"$type\" already exists. Please choose a different type or deactivate the existing one.';
  }

  @override
  String get saveFailed => 'Save Failed';

  @override
  String get errorSavingData =>
      'There was an error saving your data. Please try again.';

  @override
  String get ok => 'OK';
}
