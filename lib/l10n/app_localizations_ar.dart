// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق الإقلاع عن الإدمان';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get home => 'الرئيسية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get community => 'المجتمع';

  @override
  String get welcomeAboard => 'مرحباً بك!';

  @override
  String get welcomeMessage =>
      'لقد اتخذت الخطوة الأولى والأهم.\nنحن هنا لدعمك في رحلتك\nنحو حياة أكثر صحة.';

  @override
  String get noActiveMilestone => 'لا يوجد معلم نشط';

  @override
  String get startNewMilestone => 'بدء معلم جديد';

  @override
  String get startMyJourney => 'ابدأ رحلتي';

  @override
  String get selectMilestone => 'اختر المعلم';

  @override
  String get cancel => 'إلغاء';

  @override
  String milestoneStarted(String title) {
    return 'تم بدء $title!';
  }

  @override
  String get oneDayMilestone => 'معلم يوم واحد';

  @override
  String get oneWeekMilestone => 'معلم أسبوع واحد';

  @override
  String get twoWeeksMilestone => 'معلم أسبوعين';

  @override
  String get oneMonthMilestone => 'معلم شهر واحد';

  @override
  String get twoMonthsMilestone => 'معلم شهرين';

  @override
  String get threeMonthsMilestone => 'معلم ثلاثة أشهر';

  @override
  String get sixMonthsMilestone => 'معلم ستة أشهر';

  @override
  String get oneYearMilestone => 'معلم سنة واحدة';

  @override
  String daysMilestone(int days) {
    return 'معلم $days يوم';
  }

  @override
  String get dailySurveyHistory => 'تاريخ الاستطلاع اليومي';

  @override
  String get streakChart => 'مخطط السلسلة';

  @override
  String get moodTracker => 'تتبع المزاج';

  @override
  String get moodTrackingComingSoon => 'تتبع المزاج قريباً';

  @override
  String get noAddictionsFound => 'لم يتم العثور على إدمانات';

  @override
  String get yourAddictions => 'إدماناتك';

  @override
  String started(String date) {
    return 'بدأ: $date';
  }

  @override
  String get noSlip => 'لم ينزلق';

  @override
  String get slipped => 'انزلق';

  @override
  String get noSurvey => 'لا يوجد استطلاع';

  @override
  String get noStreakDataAvailable => 'لا توجد بيانات سلسلة متاحة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get error => 'خطأ';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get noAddictionsFoundCreateOne =>
      'لم يتم العثور على إدمانات. أنشئ واحداً للبدء!';

  @override
  String get noActiveAddictionsFound =>
      'لم يتم العثور على إدمانات نشطة. ابدأ واحداً!';

  @override
  String get failedToLoadDashboard => 'فشل تحميل لوحة التحكم';

  @override
  String get noUserIDFound =>
      'لم يتم العثور على معرف المستخدم. يرجى تسجيل الدخول.';

  @override
  String get unableToCreateMilestone => 'غير قادر على إنشاء المعلم';

  @override
  String errorCreatingMilestone(String error) {
    return 'خطأ في إنشاء المعلم: $error';
  }

  @override
  String get youAreSoberFor => 'أنت متيقظ منذ';

  @override
  String get days => 'أيام';

  @override
  String get hours => 'ساعات';

  @override
  String get minutes => 'دقائق';

  @override
  String get streak => 'السلسلة';

  @override
  String get timeSaved => 'الوقت\nالموفر';

  @override
  String get moneySaved => 'المال\nالموفر';

  @override
  String get daysUnit => 'أيام';

  @override
  String get yourDailyCheckIn => 'تسجيلك اليومي';

  @override
  String get myMood => 'مزاجي';

  @override
  String get awful => 'فظيع';

  @override
  String get sad => 'حزين';

  @override
  String get okay => 'حسناً';

  @override
  String get good => 'جيد';

  @override
  String get cravingLevel => 'مستوى الرغبة';

  @override
  String get low => 'منخفض';

  @override
  String get high => 'عالي';

  @override
  String get todayJournalOptional => 'مذكرتك اليومية (اختياري)';

  @override
  String get writeAboutYourDay => 'اكتب عن يومك...';

  @override
  String get completeCheckIn => 'إكمال التسجيل';

  @override
  String get checkInCompleted => 'تم التسجيل!';

  @override
  String get greatJobStayingOnTrack =>
      'عمل رائع في البقاء على المسار الصحيح اليوم!';

  @override
  String get checkInAgain => 'تسجيل مرة أخرى';

  @override
  String get pleaseSelectMoodAndCraving => 'يرجى اختيار المزاج ومستوى الرغبة';

  @override
  String get failedToSubmitCheckIn => 'فشل إرسال التسجيل';

  @override
  String get dailyQuote => 'اقتباس اليوم';

  @override
  String get previousAchievements => 'الإنجازات السابقة';

  @override
  String get myJourney => 'رحلتي';

  @override
  String currentStreak(int streak) {
    return 'السلسلة الحالية: $streak أيام';
  }

  @override
  String get timeSober => 'وقت اليقظة';

  @override
  String daysDays(int days) {
    return '$days أيام';
  }

  @override
  String get newAddiction => 'إدمان جديد';

  @override
  String get startTrackingNewAddiction => 'ابدأ تتبع إدمان جديد';

  @override
  String awardedOn(String date) {
    return 'تم منحه في $date';
  }

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get helloUser => 'مرحباً، المستخدم';

  @override
  String duplicateAddictionError(String type) {
    return 'يوجد بالفعل إدمان نشط من نوع \"$type\". يرجى اختيار نوع مختلف أو إلغاء تفعيل الموجود.';
  }

  @override
  String get saveFailed => 'فشل الحفظ';

  @override
  String get errorSavingData =>
      'حدث خطأ أثناء حفظ بياناتك. يرجى المحاولة مرة أخرى.';

  @override
  String get ok => 'موافق';

  @override
  String get selectAddiction => 'اختر الإدمان';

  @override
  String get whatTypeOfAddiction => 'ما نوع الإدمان\nالذي تريد الإقلاع عنه؟';

  @override
  String get searchForAddiction => 'ابحث عن إدمان...';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get noAddictionsFoundText => 'لم يتم العثور على إدمانات';

  @override
  String get whenDidYourJourneyBegin => 'متى بدأت رحلتك؟';

  @override
  String get startingDate => 'تاريخ البداية';

  @override
  String get howOftenPerWeek => 'كم مرة تقع في إدمانك في الأسبوع؟';

  @override
  String get irregularly => 'بشكل غير منتظم';

  @override
  String get selectNumberOfDays => 'اختر عدد الأيام:';

  @override
  String get howManyTimesPerDay => 'كم مرة في اليوم تقع في\nهذا الإدمان؟';

  @override
  String get quickSelection => 'اختيار سريع:';

  @override
  String get whenIFeelDeprived => 'عندما أشعر بالحرمان';

  @override
  String get sometimes => 'أحياناً';

  @override
  String get often => 'غالباً';

  @override
  String get orEnterSpecificNumber => 'أو أدخل رقماً محدداً:';

  @override
  String get egFive => 'مثلاً، 5';

  @override
  String get mainGoals => 'الأهداف الرئيسية';

  @override
  String get whatAreYourMainGoals => 'ما هي أهدافك الرئيسية؟';

  @override
  String get searchForGoal => 'ابحث عن هدف...';

  @override
  String get mainMotivation => 'الدافع الرئيسي';

  @override
  String get whatMotivatesYou => 'ما الذي يحفزك أكثر للتوقف؟\nشارك سببك...';

  @override
  String get egHealthFamily => 'مثلاً، الصحة، الأسرة، النمو الشخصي...';

  @override
  String get importance => 'الأهمية';

  @override
  String get personalImportance => 'الأهمية الشخصية';

  @override
  String get howMuchIsItImportant => 'ما مدى أهميته\nبالنسبة لك؟';

  @override
  String get justTrying => 'مجرد محاولة';

  @override
  String get itWouldBeGood => 'سيكون جيداً';

  @override
  String get iNeedIt => 'أحتاجه';

  @override
  String get critical => 'حرج';

  @override
  String get inclusion => 'المشاركة';

  @override
  String get peopleInvolved => 'الأشخاص المشاركون';

  @override
  String get whoIsInvolvedInYourJourney => 'من يشارك في رحلتك؟';

  @override
  String get justMe => 'أنا فقط';

  @override
  String get myPartner => 'شريكي';

  @override
  String get myFamily => 'عائلتي';

  @override
  String get myFriends => 'أصدقائي';

  @override
  String get myColleagues => 'زملائي';

  @override
  String get aSupportGroup => 'مجموعة دعم';

  @override
  String get myCommunity => 'مجتمعي';

  @override
  String get everyoneAroundMe => 'الجميع من حولي';

  @override
  String get financialSavings => 'التوفير المالي';

  @override
  String get howMuchMoneySavedPerDay =>
      'كم من المال تعتقد أنك يمكن أن توفره يومياً إذا توقفت؟';

  @override
  String get thisHelpsTrackFinancialProgress =>
      'هذا يساعدنا على تتبع تقدمك المالي.';

  @override
  String get enterAmount => 'أدخل المبلغ';

  @override
  String get selectCurrency => 'اختر العملة';

  @override
  String get algerianDinar => 'الدينار الجزائري';

  @override
  String get usDollar => 'الدولار الأمريكي';

  @override
  String get euro => 'اليورو';

  @override
  String get britishPound => 'الجنيه الإسترليني';

  @override
  String get indianRupee => 'الروبية الهندية';

  @override
  String get japaneseYen => 'الين الياباني';

  @override
  String get russianRuble => 'الروبل الروسي';

  @override
  String get other => 'أخرى';

  @override
  String get dailyReviewTime => 'وقت المراجعة اليومية';

  @override
  String get whenWouldYouLikeDailyReview => 'متى تود القيام\nبمراجعتك اليومية؟';

  @override
  String get chooseTimeForReflection =>
      'اختر وقتاً يمكنك فيه التفكير بهدوء. سنرسل لك تذكيراً لطيفاً.';

  @override
  String get morning => 'صباحاً';

  @override
  String get afternoon => 'مساءً';

  @override
  String get hour => 'ساعة';

  @override
  String get minute => 'دقيقة';

  @override
  String get almostThere => 'أنت قريب!';

  @override
  String get readyToBegin => 'مستعد لبدء\nتحولك';

  @override
  String get chooseUsername => 'اختر اسم مستخدم';

  @override
  String get egJohnDoe => 'مثلاً، أحمد محمد';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get heroesOfTheWeek => 'أبطال الأسبوع';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'نشر';

  @override
  String get anonymous => 'مجهول';

  @override
  String get postingToCommunity => 'النشر في المجتمع';

  @override
  String get shareYourThoughts => 'شارك أفكارك، تجاربك، أو اطلب الدعم...';

  @override
  String get postAnonymously => 'انشر بشكل مجهول';

  @override
  String get yourIdentityHidden => 'ستكون هويتك مخفية';

  @override
  String get popularTopics => 'مواضيع شائعة';

  @override
  String get photo => 'صورة';

  @override
  String get poll => 'استطلاع';

  @override
  String get emoji => 'رموز تعبيرية';

  @override
  String featureComingSoon(String feature) {
    return 'ميزة $feature قريباً!';
  }

  @override
  String get postPublishedSuccessfully => 'تم نشر المنشور بنجاح!';

  @override
  String get postPublishFailed => 'فشل نشر المنشور. يرجى المحاولة مرة أخرى.';
}
