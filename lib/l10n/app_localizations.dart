import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Addiction Quit App'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @welcomeAboard.
  ///
  /// In en, this message translates to:
  /// **'Welcome Aboard!'**
  String get welcomeAboard;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve taken the first and most important\nstep. We\'re here to support you on your\npath to a healthier life.'**
  String get welcomeMessage;

  /// No description provided for @noActiveMilestone.
  ///
  /// In en, this message translates to:
  /// **'No Active Milestone'**
  String get noActiveMilestone;

  /// No description provided for @startNewMilestone.
  ///
  /// In en, this message translates to:
  /// **'Start New Milestone'**
  String get startNewMilestone;

  /// No description provided for @startMyJourney.
  ///
  /// In en, this message translates to:
  /// **'Start My Journey'**
  String get startMyJourney;

  /// No description provided for @selectMilestone.
  ///
  /// In en, this message translates to:
  /// **'Select Milestone'**
  String get selectMilestone;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @milestoneStarted.
  ///
  /// In en, this message translates to:
  /// **'{title} started!'**
  String milestoneStarted(String title);

  /// No description provided for @oneDayMilestone.
  ///
  /// In en, this message translates to:
  /// **'1 Day Milestone'**
  String get oneDayMilestone;

  /// No description provided for @oneWeekMilestone.
  ///
  /// In en, this message translates to:
  /// **'1 Week Milestone'**
  String get oneWeekMilestone;

  /// No description provided for @twoWeeksMilestone.
  ///
  /// In en, this message translates to:
  /// **'2 Weeks Milestone'**
  String get twoWeeksMilestone;

  /// No description provided for @oneMonthMilestone.
  ///
  /// In en, this message translates to:
  /// **'1 Month Milestone'**
  String get oneMonthMilestone;

  /// No description provided for @twoMonthsMilestone.
  ///
  /// In en, this message translates to:
  /// **'2 Months Milestone'**
  String get twoMonthsMilestone;

  /// No description provided for @threeMonthsMilestone.
  ///
  /// In en, this message translates to:
  /// **'3 Months Milestone'**
  String get threeMonthsMilestone;

  /// No description provided for @sixMonthsMilestone.
  ///
  /// In en, this message translates to:
  /// **'6 Months Milestone'**
  String get sixMonthsMilestone;

  /// No description provided for @oneYearMilestone.
  ///
  /// In en, this message translates to:
  /// **'1 Year Milestone'**
  String get oneYearMilestone;

  /// No description provided for @daysMilestone.
  ///
  /// In en, this message translates to:
  /// **'{days} Days Milestone'**
  String daysMilestone(int days);

  /// No description provided for @dailySurveyHistory.
  ///
  /// In en, this message translates to:
  /// **'Daily Survey History'**
  String get dailySurveyHistory;

  /// No description provided for @streakChart.
  ///
  /// In en, this message translates to:
  /// **'Streak Chart'**
  String get streakChart;

  /// No description provided for @moodTracker.
  ///
  /// In en, this message translates to:
  /// **'Mood Tracker'**
  String get moodTracker;

  /// No description provided for @moodTrackingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Mood tracking coming soon'**
  String get moodTrackingComingSoon;

  /// No description provided for @noAddictionsFound.
  ///
  /// In en, this message translates to:
  /// **'No addictions found'**
  String get noAddictionsFound;

  /// No description provided for @yourAddictions.
  ///
  /// In en, this message translates to:
  /// **'Your Addictions'**
  String get yourAddictions;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started: {date}'**
  String started(String date);

  /// No description provided for @noSlip.
  ///
  /// In en, this message translates to:
  /// **'No Slip'**
  String get noSlip;

  /// No description provided for @slipped.
  ///
  /// In en, this message translates to:
  /// **'Slipped'**
  String get slipped;

  /// No description provided for @noSurvey.
  ///
  /// In en, this message translates to:
  /// **'No Survey'**
  String get noSurvey;

  /// No description provided for @noStreakDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No streak data available'**
  String get noStreakDataAvailable;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noAddictionsFoundCreateOne.
  ///
  /// In en, this message translates to:
  /// **'No addictions found. Create one to start!'**
  String get noAddictionsFoundCreateOne;

  /// No description provided for @noActiveAddictionsFound.
  ///
  /// In en, this message translates to:
  /// **'No active addictions found. Start one!'**
  String get noActiveAddictionsFound;

  /// No description provided for @failedToLoadDashboard.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard'**
  String get failedToLoadDashboard;

  /// No description provided for @noUserIDFound.
  ///
  /// In en, this message translates to:
  /// **'No user ID found. Please login.'**
  String get noUserIDFound;

  /// No description provided for @unableToCreateMilestone.
  ///
  /// In en, this message translates to:
  /// **'Unable to create milestone'**
  String get unableToCreateMilestone;

  /// No description provided for @errorCreatingMilestone.
  ///
  /// In en, this message translates to:
  /// **'Error creating milestone: {error}'**
  String errorCreatingMilestone(String error);

  /// No description provided for @youAreSoberFor.
  ///
  /// In en, this message translates to:
  /// **'You are sober for'**
  String get youAreSoberFor;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'HOURS'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'MIN'**
  String get minutes;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @timeSaved.
  ///
  /// In en, this message translates to:
  /// **'Time\nSaved'**
  String get timeSaved;

  /// No description provided for @moneySaved.
  ///
  /// In en, this message translates to:
  /// **'Money\nSaved'**
  String get moneySaved;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysUnit;

  /// No description provided for @yourDailyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Check-in'**
  String get yourDailyCheckIn;

  /// No description provided for @myMood.
  ///
  /// In en, this message translates to:
  /// **'My Mood'**
  String get myMood;

  /// No description provided for @awful.
  ///
  /// In en, this message translates to:
  /// **'Awful'**
  String get awful;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @cravingLevel.
  ///
  /// In en, this message translates to:
  /// **'Craving Level'**
  String get cravingLevel;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @todayJournalOptional.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Journal (Optional)'**
  String get todayJournalOptional;

  /// No description provided for @writeAboutYourDay.
  ///
  /// In en, this message translates to:
  /// **'Write about your day...'**
  String get writeAboutYourDay;

  /// No description provided for @completeCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Complete Check-in'**
  String get completeCheckIn;

  /// No description provided for @checkInCompleted.
  ///
  /// In en, this message translates to:
  /// **'Check-In Completed!'**
  String get checkInCompleted;

  /// No description provided for @greatJobStayingOnTrack.
  ///
  /// In en, this message translates to:
  /// **'Great job staying on track today!'**
  String get greatJobStayingOnTrack;

  /// No description provided for @checkInAgain.
  ///
  /// In en, this message translates to:
  /// **'Check In Again'**
  String get checkInAgain;

  /// No description provided for @pleaseSelectMoodAndCraving.
  ///
  /// In en, this message translates to:
  /// **'Please select mood and craving level'**
  String get pleaseSelectMoodAndCraving;

  /// No description provided for @failedToSubmitCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit check-in'**
  String get failedToSubmitCheckIn;

  /// No description provided for @dailyQuote.
  ///
  /// In en, this message translates to:
  /// **'Daily Quote'**
  String get dailyQuote;

  /// No description provided for @previousAchievements.
  ///
  /// In en, this message translates to:
  /// **'Previous Achievements'**
  String get previousAchievements;

  /// No description provided for @myJourney.
  ///
  /// In en, this message translates to:
  /// **'My Journey'**
  String get myJourney;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak: {streak} days'**
  String currentStreak(int streak);

  /// No description provided for @timeSober.
  ///
  /// In en, this message translates to:
  /// **'Time Sober'**
  String get timeSober;

  /// No description provided for @daysDays.
  ///
  /// In en, this message translates to:
  /// **'{days} Days'**
  String daysDays(int days);

  /// No description provided for @newAddiction.
  ///
  /// In en, this message translates to:
  /// **'New Addiction'**
  String get newAddiction;

  /// No description provided for @startTrackingNewAddiction.
  ///
  /// In en, this message translates to:
  /// **'Start tracking a new addiction'**
  String get startTrackingNewAddiction;

  /// No description provided for @awardedOn.
  ///
  /// In en, this message translates to:
  /// **'Awarded on {date}'**
  String awardedOn(String date);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, User'**
  String get helloUser;

  /// No description provided for @duplicateAddictionError.
  ///
  /// In en, this message translates to:
  /// **'An active addiction of type \"{type}\" already exists. Please choose a different type or deactivate the existing one.'**
  String duplicateAddictionError(String type);

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save Failed'**
  String get saveFailed;

  /// No description provided for @errorSavingData.
  ///
  /// In en, this message translates to:
  /// **'There was an error saving your data. Please try again.'**
  String get errorSavingData;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @selectAddiction.
  ///
  /// In en, this message translates to:
  /// **'Select Addiction'**
  String get selectAddiction;

  /// No description provided for @whatTypeOfAddiction.
  ///
  /// In en, this message translates to:
  /// **'What type of addiction\ndo you want to quit?'**
  String get whatTypeOfAddiction;

  /// No description provided for @searchForAddiction.
  ///
  /// In en, this message translates to:
  /// **'Search for an addiction...'**
  String get searchForAddiction;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @noAddictionsFoundText.
  ///
  /// In en, this message translates to:
  /// **'No addictions found'**
  String get noAddictionsFoundText;

  /// No description provided for @whenDidYourJourneyBegin.
  ///
  /// In en, this message translates to:
  /// **'When did your journey begin?'**
  String get whenDidYourJourneyBegin;

  /// No description provided for @startingDate.
  ///
  /// In en, this message translates to:
  /// **'Starting Date'**
  String get startingDate;

  /// No description provided for @howOftenPerWeek.
  ///
  /// In en, this message translates to:
  /// **'How often do you fall into your addiction per week?'**
  String get howOftenPerWeek;

  /// No description provided for @irregularly.
  ///
  /// In en, this message translates to:
  /// **'Irregularly'**
  String get irregularly;

  /// No description provided for @selectNumberOfDays.
  ///
  /// In en, this message translates to:
  /// **'Select number of days:'**
  String get selectNumberOfDays;

  /// No description provided for @howManyTimesPerDay.
  ///
  /// In en, this message translates to:
  /// **'How many times per day do you fall into\nthis addiction?'**
  String get howManyTimesPerDay;

  /// No description provided for @quickSelection.
  ///
  /// In en, this message translates to:
  /// **'Quick selection:'**
  String get quickSelection;

  /// No description provided for @whenIFeelDeprived.
  ///
  /// In en, this message translates to:
  /// **'When I feel deprived'**
  String get whenIFeelDeprived;

  /// No description provided for @sometimes.
  ///
  /// In en, this message translates to:
  /// **'Sometimes'**
  String get sometimes;

  /// No description provided for @often.
  ///
  /// In en, this message translates to:
  /// **'Often'**
  String get often;

  /// No description provided for @orEnterSpecificNumber.
  ///
  /// In en, this message translates to:
  /// **'Or enter specific number:'**
  String get orEnterSpecificNumber;

  /// No description provided for @egFive.
  ///
  /// In en, this message translates to:
  /// **'e.g., 5'**
  String get egFive;

  /// No description provided for @mainGoals.
  ///
  /// In en, this message translates to:
  /// **'Main Goals'**
  String get mainGoals;

  /// No description provided for @whatAreYourMainGoals.
  ///
  /// In en, this message translates to:
  /// **'What are your main goals?'**
  String get whatAreYourMainGoals;

  /// No description provided for @searchForGoal.
  ///
  /// In en, this message translates to:
  /// **'Search for a goal...'**
  String get searchForGoal;

  /// No description provided for @mainMotivation.
  ///
  /// In en, this message translates to:
  /// **'Main Motivation'**
  String get mainMotivation;

  /// No description provided for @whatMotivatesYou.
  ///
  /// In en, this message translates to:
  /// **'What motivates you the most to stop?\nShare your reason...'**
  String get whatMotivatesYou;

  /// No description provided for @egHealthFamily.
  ///
  /// In en, this message translates to:
  /// **'e.g., Health, family, personal growth...'**
  String get egHealthFamily;

  /// No description provided for @importance.
  ///
  /// In en, this message translates to:
  /// **'Importance'**
  String get importance;

  /// No description provided for @personalImportance.
  ///
  /// In en, this message translates to:
  /// **'Personal Importance'**
  String get personalImportance;

  /// No description provided for @howMuchIsItImportant.
  ///
  /// In en, this message translates to:
  /// **'How much is it important\nto you?'**
  String get howMuchIsItImportant;

  /// No description provided for @justTrying.
  ///
  /// In en, this message translates to:
  /// **'Just trying'**
  String get justTrying;

  /// No description provided for @itWouldBeGood.
  ///
  /// In en, this message translates to:
  /// **'It would be good'**
  String get itWouldBeGood;

  /// No description provided for @iNeedIt.
  ///
  /// In en, this message translates to:
  /// **'I need it'**
  String get iNeedIt;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @inclusion.
  ///
  /// In en, this message translates to:
  /// **'Inclusion'**
  String get inclusion;

  /// No description provided for @peopleInvolved.
  ///
  /// In en, this message translates to:
  /// **'People Involved'**
  String get peopleInvolved;

  /// No description provided for @whoIsInvolvedInYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Who is involved in your journey?'**
  String get whoIsInvolvedInYourJourney;

  /// No description provided for @justMe.
  ///
  /// In en, this message translates to:
  /// **'Just me'**
  String get justMe;

  /// No description provided for @myPartner.
  ///
  /// In en, this message translates to:
  /// **'My partner'**
  String get myPartner;

  /// No description provided for @myFamily.
  ///
  /// In en, this message translates to:
  /// **'My family'**
  String get myFamily;

  /// No description provided for @myFriends.
  ///
  /// In en, this message translates to:
  /// **'My friends'**
  String get myFriends;

  /// No description provided for @myColleagues.
  ///
  /// In en, this message translates to:
  /// **'My colleagues'**
  String get myColleagues;

  /// No description provided for @aSupportGroup.
  ///
  /// In en, this message translates to:
  /// **'A support group'**
  String get aSupportGroup;

  /// No description provided for @myCommunity.
  ///
  /// In en, this message translates to:
  /// **'My community'**
  String get myCommunity;

  /// No description provided for @everyoneAroundMe.
  ///
  /// In en, this message translates to:
  /// **'Everyone around me'**
  String get everyoneAroundMe;

  /// No description provided for @financialSavings.
  ///
  /// In en, this message translates to:
  /// **'Financial Savings'**
  String get financialSavings;

  /// No description provided for @howMuchMoneySavedPerDay.
  ///
  /// In en, this message translates to:
  /// **'How much money do you think you can spare per day if you stop?'**
  String get howMuchMoneySavedPerDay;

  /// No description provided for @thisHelpsTrackFinancialProgress.
  ///
  /// In en, this message translates to:
  /// **'This helps us track your financial progress.'**
  String get thisHelpsTrackFinancialProgress;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select currency'**
  String get selectCurrency;

  /// No description provided for @algerianDinar.
  ///
  /// In en, this message translates to:
  /// **'Algerian Dinar'**
  String get algerianDinar;

  /// No description provided for @usDollar.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get usDollar;

  /// No description provided for @euro.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get euro;

  /// No description provided for @britishPound.
  ///
  /// In en, this message translates to:
  /// **'British Pound'**
  String get britishPound;

  /// No description provided for @indianRupee.
  ///
  /// In en, this message translates to:
  /// **'Indian Rupee'**
  String get indianRupee;

  /// No description provided for @japaneseYen.
  ///
  /// In en, this message translates to:
  /// **'Japanese Yen'**
  String get japaneseYen;

  /// No description provided for @russianRuble.
  ///
  /// In en, this message translates to:
  /// **'Russian Ruble'**
  String get russianRuble;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @dailyReviewTime.
  ///
  /// In en, this message translates to:
  /// **'Daily Review Time'**
  String get dailyReviewTime;

  /// No description provided for @whenWouldYouLikeDailyReview.
  ///
  /// In en, this message translates to:
  /// **'When would you like to\ndo your daily review?'**
  String get whenWouldYouLikeDailyReview;

  /// No description provided for @chooseTimeForReflection.
  ///
  /// In en, this message translates to:
  /// **'Choose a time when you can reflect quietly. We\'ll send a gentle reminder.'**
  String get chooseTimeForReflection;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'HOUR'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'MINUTE'**
  String get minute;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost There!'**
  String get almostThere;

  /// No description provided for @readyToBegin.
  ///
  /// In en, this message translates to:
  /// **'Ready to begin your\ntransformation'**
  String get readyToBegin;

  /// No description provided for @chooseUsername.
  ///
  /// In en, this message translates to:
  /// **'Choose a username'**
  String get chooseUsername;

  /// No description provided for @egJohnDoe.
  ///
  /// In en, this message translates to:
  /// **'e.g., John Doe'**
  String get egJohnDoe;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @heroesOfTheWeek.
  ///
  /// In en, this message translates to:
  /// **'Heroes of the Week'**
  String get heroesOfTheWeek;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @postingToCommunity.
  ///
  /// In en, this message translates to:
  /// **'Posting to Community'**
  String get postingToCommunity;

  /// No description provided for @shareYourThoughts.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts, experiences, or ask for support...'**
  String get shareYourThoughts;

  /// No description provided for @postAnonymously.
  ///
  /// In en, this message translates to:
  /// **'Post anonymously'**
  String get postAnonymously;

  /// No description provided for @yourIdentityHidden.
  ///
  /// In en, this message translates to:
  /// **'Your identity will be hidden'**
  String get yourIdentityHidden;

  /// No description provided for @popularTopics.
  ///
  /// In en, this message translates to:
  /// **'Popular topics'**
  String get popularTopics;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @poll.
  ///
  /// In en, this message translates to:
  /// **'Poll'**
  String get poll;

  /// No description provided for @emoji.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get emoji;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} feature coming soon!'**
  String featureComingSoon(String feature);

  /// No description provided for @postPublishedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Post published successfully!'**
  String get postPublishedSuccessfully;

  /// No description provided for @postPublishFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to publish post. Please try again.'**
  String get postPublishFailed;

  /// No description provided for @milestone1Day.
  ///
  /// In en, this message translates to:
  /// **'Day 1 – First Step'**
  String get milestone1Day;

  /// No description provided for @milestone3Days.
  ///
  /// In en, this message translates to:
  /// **'Day 3 – Early Momentum'**
  String get milestone3Days;

  /// No description provided for @milestone7Days.
  ///
  /// In en, this message translates to:
  /// **'Day 7 – First Week'**
  String get milestone7Days;

  /// No description provided for @milestone14Days.
  ///
  /// In en, this message translates to:
  /// **'Day 14 – Fortnight Checkpoint'**
  String get milestone14Days;

  /// No description provided for @milestone21Days.
  ///
  /// In en, this message translates to:
  /// **'Day 21 – Habit Builder'**
  String get milestone21Days;

  /// No description provided for @milestone30Days.
  ///
  /// In en, this message translates to:
  /// **'Day 30 – First Month'**
  String get milestone30Days;

  /// No description provided for @milestone40Days.
  ///
  /// In en, this message translates to:
  /// **'Day 40 – Steady Streak'**
  String get milestone40Days;

  /// No description provided for @milestone50Days.
  ///
  /// In en, this message translates to:
  /// **'Day 50 – Midway Motivation'**
  String get milestone50Days;

  /// No description provided for @milestone60Days.
  ///
  /// In en, this message translates to:
  /// **'Day 60 – Two Months Strong'**
  String get milestone60Days;

  /// No description provided for @milestone75Days.
  ///
  /// In en, this message translates to:
  /// **'Day 75 – Persistence Reward'**
  String get milestone75Days;

  /// No description provided for @milestone90Days.
  ///
  /// In en, this message translates to:
  /// **'Day 90 – Quarter Milestone'**
  String get milestone90Days;

  /// No description provided for @milestone100Days.
  ///
  /// In en, this message translates to:
  /// **'Day 100 – Century Marker'**
  String get milestone100Days;

  /// No description provided for @milestone120Days.
  ///
  /// In en, this message translates to:
  /// **'Day 120 – Four-Month Achievement'**
  String get milestone120Days;

  /// No description provided for @milestone150Days.
  ///
  /// In en, this message translates to:
  /// **'Day 150 – Streak Recognition'**
  String get milestone150Days;

  /// No description provided for @milestone180Days.
  ///
  /// In en, this message translates to:
  /// **'Day 180 – Half-Year Hero'**
  String get milestone180Days;

  /// No description provided for @milestone200Days.
  ///
  /// In en, this message translates to:
  /// **'Day 200 – Beyond the Horizon'**
  String get milestone200Days;

  /// No description provided for @milestone250Days.
  ///
  /// In en, this message translates to:
  /// **'Day 250 – Almost There'**
  String get milestone250Days;

  /// No description provided for @milestone300Days.
  ///
  /// In en, this message translates to:
  /// **'Day 300 – Nine-Month Triumph'**
  String get milestone300Days;

  /// No description provided for @milestone365Days.
  ///
  /// In en, this message translates to:
  /// **'Day 365 – One Year Victory'**
  String get milestone365Days;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @parameters.
  ///
  /// In en, this message translates to:
  /// **'Parameters'**
  String get parameters;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @areYouSureWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureWantToLogout;

  /// No description provided for @addictionQuit.
  ///
  /// In en, this message translates to:
  /// **'Addiction Quit'**
  String get addictionQuit;

  /// No description provided for @yourJourneyToRecovery.
  ///
  /// In en, this message translates to:
  /// **'Your Journey to Recovery'**
  String get yourJourneyToRecovery;

  /// No description provided for @aboutThisApp.
  ///
  /// In en, this message translates to:
  /// **'About This App'**
  String get aboutThisApp;

  /// No description provided for @aboutThisAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Addiction Quit is a comprehensive mobile application designed to help individuals overcome addiction and maintain sobriety. The app provides daily check-ins, progress tracking, financial savings calculations, and motivational support through quotes and milestones.'**
  String get aboutThisAppDescription;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @sobrietyCounter.
  ///
  /// In en, this message translates to:
  /// **'Sobriety Counter'**
  String get sobrietyCounter;

  /// No description provided for @sobrietyCounterDescription.
  ///
  /// In en, this message translates to:
  /// **'Track your sobriety progress in real-time'**
  String get sobrietyCounterDescription;

  /// No description provided for @dailyCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-ins'**
  String get dailyCheckIns;

  /// No description provided for @dailyCheckInsDescription.
  ///
  /// In en, this message translates to:
  /// **'Log your mood, cravings, and journal entries'**
  String get dailyCheckInsDescription;

  /// No description provided for @progressTracking.
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get progressTracking;

  /// No description provided for @progressTrackingDescription.
  ///
  /// In en, this message translates to:
  /// **'Visualize your achievements and milestones'**
  String get progressTrackingDescription;

  /// No description provided for @savingsCalculator.
  ///
  /// In en, this message translates to:
  /// **'Savings Calculator'**
  String get savingsCalculator;

  /// No description provided for @savingsCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'See how much money you\'ve saved'**
  String get savingsCalculatorDescription;

  /// No description provided for @dailyInspiration.
  ///
  /// In en, this message translates to:
  /// **'Daily Inspiration'**
  String get dailyInspiration;

  /// No description provided for @dailyInspirationDescription.
  ///
  /// In en, this message translates to:
  /// **'Get motivated with daily quotes'**
  String get dailyInspirationDescription;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// No description provided for @cloudSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Sync your data across devices securely'**
  String get cloudSyncDescription;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @releaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDate;

  /// No description provided for @releaseDateValue.
  ///
  /// In en, this message translates to:
  /// **'January 2026'**
  String get releaseDateValue;

  /// No description provided for @supportAndFeedback.
  ///
  /// In en, this message translates to:
  /// **'Support & Feedback'**
  String get supportAndFeedback;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @viewOurPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'View our privacy policy'**
  String get viewOurPrivacyPolicy;

  /// No description provided for @claimReward.
  ///
  /// In en, this message translates to:
  /// **'Claim Reward'**
  String get claimReward;

  /// No description provided for @congratulationsRewardClaimed.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Reward claimed!'**
  String get congratulationsRewardClaimed;

  /// No description provided for @failedToClaimReward.
  ///
  /// In en, this message translates to:
  /// **'Failed to claim reward'**
  String get failedToClaimReward;

  /// No description provided for @youAlreadyHaveActiveMilestone.
  ///
  /// In en, this message translates to:
  /// **'You already have an active milestone. Complete or reset it first.'**
  String get youAlreadyHaveActiveMilestone;

  /// No description provided for @signInOrCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to sync your progress.'**
  String get signInOrCreateAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @yourJourneyToBetterYou.
  ///
  /// In en, this message translates to:
  /// **'Your journey to a better you'**
  String get yourJourneyToBetterYou;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @startYourRecoveryJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your recovery journey today'**
  String get startYourRecoveryJourney;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @reEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterYourPassword;

  /// No description provided for @pleaseConfirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// No description provided for @passwordMustBeAtLeast6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @slips.
  ///
  /// In en, this message translates to:
  /// **'Slips'**
  String get slips;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @counterResetSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Counter reset successfully'**
  String get counterResetSuccessfully;

  /// No description provided for @failedToResetCounter.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset counter'**
  String get failedToResetCounter;

  /// No description provided for @didYouSlipToday.
  ///
  /// In en, this message translates to:
  /// **'Did you slip today?'**
  String get didYouSlipToday;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @howManyTimes.
  ///
  /// In en, this message translates to:
  /// **'How many times?'**
  String get howManyTimes;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @h.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get h;

  /// No description provided for @d.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get d;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
