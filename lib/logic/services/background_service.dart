
import 'package:flutter/widgets.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

// Import your other services
import 'notif_service.dart';
import '../../data/databases/db_helper.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

class BackgroundService {
  // Unique ID for the alarm
  static const int _dailyAlarmId = 888;

  /// Initialize the background service (if needed, e.g. for channels)
  static Future<void> initialize() async {
    // AndroidAlarmManager is already initialized in main.dart
  }

  /// Schedule the daily reminder
  static Future<void> scheduleDailyNotification(int hour, int minute) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Calculate startAt time for AndroidAlarmManager
    // We want it to repeat daily, so we set exact, wakeup, and rescheduleOnReboot
    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      _dailyAlarmId,
      _onAlarmTriggered,
      startAt: scheduledDate,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
    
    print("Scheduled daily alarm for $scheduledDate (ID: $_dailyAlarmId)");
  }

  /// Cancel the daily reminder
  static Future<void> cancelDailyNotification() async {
    await AndroidAlarmManager.cancel(_dailyAlarmId);
  }

  /// The static callback function that runs in the background isolate
  @pragma('vm:entry-point')
  static Future<void> _onAlarmTriggered() async {
    // 1. Initialize Flutter bindings for platform channels
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Initialize timezone (needed for notifications if you use zonedSchedule, 
    // though here we are triggering immediately from alarm callback)
    tz.initializeTimeZones();

    try {
      // 3. Initialize NotificationService
      final notifService = NotificationService();
      await notifService.init();

      // 4. Initialize Database
       final dbHelper = DatabaseHelper.instance;
       await dbHelper.database; // Open DB

      // 5. Get Language Preference
      // SharedPreferences works in background isolate on Android
      final languageCode = await SharedPreferencesHelper.getLanguage();
      final isArabic = languageCode == 'ar';
      
      // -- NEW: Feature Checks --
      
      // A. Check if user has an active addiction
      final currentAddictionId = await SharedPreferencesHelper.getAddictionId();
      if (currentAddictionId == null) {
        print("No active addiction found. Skipping notification.");
        return;
      }
      
      // B. Check if daily check-in is already completed for today
      // The 'daily_surveys' table tracks check-ins.
      // We need to query if a record exists for:
      // - current user (userId)
      // - current addiction (currentAddictionId)
      // - today's date
      
      final db = await dbHelper.database;
      final userId = await SharedPreferencesHelper.getUserId();
      
      if (userId == null) {
         print("User ID not found. Skipping notification.");
         return;
      }

      final todayStr = DateTime.now().toIso8601String().split('T')[0];
      
      final List<Map<String, dynamic>> existingSurveys = await db.query(
        'daily_surveys',
        where: 'user_id = ? AND addiction_id = ? AND date LIKE ?',
        whereArgs: [userId, currentAddictionId, '$todayStr%'],
      );
      
      if (existingSurveys.isNotEmpty) {
        print("Daily check-in already completed for today ($todayStr). Skipping notification.");
        return;
      }

      // -- End Feature Checks --

      // 6. Define localized message
      final title = isArabic ? 'تذكير يومي' : 'Daily Reminder';
      final body = isArabic 
          ? 'وقت تسجيلك اليومي' 
          : 'Time for your daily checkin';

      // 7. Show Notification
      // Use a distinct ID for the notification itself
      const notificationId = 999; 
      await notifService.showNotification(
        id: notificationId,
        title: title,
        body: body,
        payload: 'daily_checkin',
      );

      // 8. Log to Database
      // Insert into 'notifications' table
      
      await db.insert('notifications', {
        'user_id': userId,
        'type': 'reminder',
        'title': title,
        'message': body,
        'created_at': DateTime.now().toIso8601String(),
        'is_read': 0, // Unread
      });
      print("Logged notification to database for user $userId");

    } catch (e, stack) {
      print("Error in background alarm: $e");
      print(stack);
    }
  }
}
