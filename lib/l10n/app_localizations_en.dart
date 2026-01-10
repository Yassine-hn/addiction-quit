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
  String get days => 'days';

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

  @override
  String get milestone1Day => 'Day 1 – First Step';

  @override
  String get milestone3Days => 'Day 3 – Early Momentum';

  @override
  String get milestone7Days => 'Day 7 – First Week';

  @override
  String get milestone14Days => 'Day 14 – Fortnight Checkpoint';

  @override
  String get milestone21Days => 'Day 21 – Habit Builder';

  @override
  String get milestone30Days => 'Day 30 – First Month';

  @override
  String get milestone40Days => 'Day 40 – Steady Streak';

  @override
  String get milestone50Days => 'Day 50 – Midway Motivation';

  @override
  String get milestone60Days => 'Day 60 – Two Months Strong';

  @override
  String get milestone75Days => 'Day 75 – Persistence Reward';

  @override
  String get milestone90Days => 'Day 90 – Quarter Milestone';

  @override
  String get milestone100Days => 'Day 100 – Century Marker';

  @override
  String get milestone120Days => 'Day 120 – Four-Month Achievement';

  @override
  String get milestone150Days => 'Day 150 – Streak Recognition';

  @override
  String get milestone180Days => 'Day 180 – Half-Year Hero';

  @override
  String get milestone200Days => 'Day 200 – Beyond the Horizon';

  @override
  String get milestone250Days => 'Day 250 – Almost There';

  @override
  String get milestone300Days => 'Day 300 – Nine-Month Triumph';

  @override
  String get milestone365Days => 'Day 365 – One Year Victory';

  @override
  String get notifications => 'Notifications';

  @override
  String get parameters => 'Parameters';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get logout => 'Logout';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get areYouSureWantToLogout => 'Are you sure you want to logout?';

  @override
  String get addictionQuit => 'Addiction Quit';

  @override
  String get yourJourneyToRecovery => 'Your Journey to Recovery';

  @override
  String get aboutThisApp => 'About This App';

  @override
  String get aboutThisAppDescription =>
      'Addiction Quit is a comprehensive mobile application designed to help individuals overcome addiction and maintain sobriety. The app provides daily check-ins, progress tracking, financial savings calculations, and motivational support through quotes and milestones.';

  @override
  String get keyFeatures => 'Key Features';

  @override
  String get sobrietyCounter => 'Sobriety Counter';

  @override
  String get sobrietyCounterDescription =>
      'Track your sobriety progress in real-time';

  @override
  String get dailyCheckIns => 'Daily Check-ins';

  @override
  String get dailyCheckInsDescription =>
      'Log your mood, cravings, and journal entries';

  @override
  String get progressTracking => 'Progress Tracking';

  @override
  String get progressTrackingDescription =>
      'Visualize your achievements and milestones';

  @override
  String get savingsCalculator => 'Savings Calculator';

  @override
  String get savingsCalculatorDescription => 'See how much money you\'ve saved';

  @override
  String get dailyInspiration => 'Daily Inspiration';

  @override
  String get dailyInspirationDescription => 'Get motivated with daily quotes';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get cloudSyncDescription => 'Sync your data across devices securely';

  @override
  String get appVersion => 'App Version';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get releaseDate => 'Release Date';

  @override
  String get releaseDateValue => 'January 2026';

  @override
  String get supportAndFeedback => 'Support & Feedback';

  @override
  String get email => 'Email';

  @override
  String get website => 'Website';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get viewOurPrivacyPolicy => 'View our privacy policy';

  @override
  String get claimReward => 'Claim Reward';

  @override
  String get congratulationsRewardClaimed => 'Congratulations! Reward claimed!';

  @override
  String get failedToClaimReward => 'Failed to claim reward';

  @override
  String get youAlreadyHaveActiveMilestone =>
      'You already have an active milestone. Complete or reset it first.';

  @override
  String get signInOrCreateAccount =>
      'Sign in or create an account to sync your progress.';

  @override
  String get signUp => 'Sign up';

  @override
  String get yourJourneyToBetterYou => 'Your journey to a better you';

  @override
  String get current => 'Current';

  @override
  String get login => 'Login';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get emailLabel => 'Email';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get pleaseEnterYourEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get pleaseEnterYourPassword => 'Please enter your password';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get startYourRecoveryJourney => 'Start your recovery journey today';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get reEnterYourPassword => 'Re-enter your password';

  @override
  String get pleaseConfirmYourPassword => 'Please confirm your password';

  @override
  String get passwordMustBeAtLeast6 => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get slips => 'Slips';

  @override
  String get reset => 'Reset';

  @override
  String get counterResetSuccessfully => 'Counter reset successfully';

  @override
  String get failedToResetCounter => 'Failed to reset counter';

  @override
  String get didYouSlipToday => 'Did you slip today?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get howManyTimes => 'How many times?';

  @override
  String get min => 'min';

  @override
  String get h => 'h';

  @override
  String get d => 'd';
}
