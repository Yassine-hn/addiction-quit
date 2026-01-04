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

  @override
  String get selectAddiction => 'Select Addiction';

  @override
  String get whatTypeOfAddiction =>
      'What type of addiction\ndo you want to quit?';

  @override
  String get searchForAddiction => 'Search for an addiction...';

  @override
  String get continueLabel => 'Continue';

  @override
  String get noAddictionsFoundText => 'No addictions found';

  @override
  String get whenDidYourJourneyBegin => 'When did your journey begin?';

  @override
  String get startingDate => 'Starting Date';

  @override
  String get howOftenPerWeek =>
      'How often do you fall into your addiction per week?';

  @override
  String get irregularly => 'Irregularly';

  @override
  String get selectNumberOfDays => 'Select number of days:';

  @override
  String get howManyTimesPerDay =>
      'How many times per day do you fall into\nthis addiction?';

  @override
  String get quickSelection => 'Quick selection:';

  @override
  String get whenIFeelDeprived => 'When I feel deprived';

  @override
  String get sometimes => 'Sometimes';

  @override
  String get often => 'Often';

  @override
  String get orEnterSpecificNumber => 'Or enter specific number:';

  @override
  String get egFive => 'e.g., 5';

  @override
  String get mainGoals => 'Main Goals';

  @override
  String get whatAreYourMainGoals => 'What are your main goals?';

  @override
  String get searchForGoal => 'Search for a goal...';

  @override
  String get mainMotivation => 'Main Motivation';

  @override
  String get whatMotivatesYou =>
      'What motivates you the most to stop?\nShare your reason...';

  @override
  String get egHealthFamily => 'e.g., Health, family, personal growth...';

  @override
  String get importance => 'Importance';

  @override
  String get personalImportance => 'Personal Importance';

  @override
  String get howMuchIsItImportant => 'How much is it important\nto you?';

  @override
  String get justTrying => 'Just trying';

  @override
  String get itWouldBeGood => 'It would be good';

  @override
  String get iNeedIt => 'I need it';

  @override
  String get critical => 'Critical';

  @override
  String get inclusion => 'Inclusion';

  @override
  String get peopleInvolved => 'People Involved';

  @override
  String get whoIsInvolvedInYourJourney => 'Who is involved in your journey?';

  @override
  String get justMe => 'Just me';

  @override
  String get myPartner => 'My partner';

  @override
  String get myFamily => 'My family';

  @override
  String get myFriends => 'My friends';

  @override
  String get myColleagues => 'My colleagues';

  @override
  String get aSupportGroup => 'A support group';

  @override
  String get myCommunity => 'My community';

  @override
  String get everyoneAroundMe => 'Everyone around me';

  @override
  String get financialSavings => 'Financial Savings';

  @override
  String get howMuchMoneySavedPerDay =>
      'How much money do you think you can spare per day if you stop?';

  @override
  String get thisHelpsTrackFinancialProgress =>
      'This helps us track your financial progress.';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get algerianDinar => 'Algerian Dinar';

  @override
  String get usDollar => 'US Dollar';

  @override
  String get euro => 'Euro';

  @override
  String get britishPound => 'British Pound';

  @override
  String get indianRupee => 'Indian Rupee';

  @override
  String get japaneseYen => 'Japanese Yen';

  @override
  String get russianRuble => 'Russian Ruble';

  @override
  String get other => 'Other';

  @override
  String get dailyReviewTime => 'Daily Review Time';

  @override
  String get whenWouldYouLikeDailyReview =>
      'When would you like to\ndo your daily review?';

  @override
  String get chooseTimeForReflection =>
      'Choose a time when you can reflect quietly. We\'ll send a gentle reminder.';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get hour => 'HOUR';

  @override
  String get minute => 'MINUTE';

  @override
  String get almostThere => 'Almost There!';

  @override
  String get readyToBegin => 'Ready to begin your\ntransformation';

  @override
  String get chooseUsername => 'Choose a username';

  @override
  String get egJohnDoe => 'e.g., John Doe';

  @override
  String get getStarted => 'Get Started';

  @override
  String get heroesOfTheWeek => 'Heroes of the Week';

  @override
  String get createPost => 'Create Post';

  @override
  String get post => 'Post';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get postingToCommunity => 'Posting to Community';

  @override
  String get shareYourThoughts =>
      'Share your thoughts, experiences, or ask for support...';

  @override
  String get postAnonymously => 'Post anonymously';

  @override
  String get yourIdentityHidden => 'Your identity will be hidden';

  @override
  String get popularTopics => 'Popular topics';

  @override
  String get photo => 'Photo';

  @override
  String get poll => 'Poll';

  @override
  String get emoji => 'Emoji';

  @override
  String featureComingSoon(String feature) {
    return '$feature feature coming soon!';
  }

  @override
  String get postPublishedSuccessfully => 'Post published successfully!';

  @override
  String get postPublishFailed => 'Failed to publish post. Please try again.';
}
