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
}
