// Fonctions to implement for home_screen backend
// Now using repositories to fetch data from database

// Note: Localization is handled in UI layer, not in backend functions
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/sobriety_repository.dart';
import '../../data/repositories/savings_repository.dart';
import '../../data/repositories/check_in_repository.dart';
import '../../data/repositories/quote_repository.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

// Repository instances (singleton pattern)
final _userRepository = UserRepositoryImpl();
final _sobrietyRepository = SobrietyRepositoryImpl();
final _savingsRepository = SavingsRepositoryImpl();
final _checkInRepository = CheckInRepositoryImpl();
final _quoteRepository = QuoteRepositoryImpl();

/// Get sobriety time for the user's primary addiction
Future<Map<String, String>> getSobrietyTime() async {
  try {
    final userId = await SharedPreferencesHelper.getUserId();
    final addictionId = await SharedPreferencesHelper.getAddictionId();
    return await _sobrietyRepository.getSobrietyTime(
      userId: userId,
      addictionId: addictionId,
    );
  } catch (e) {
    print('Error getting sobriety time: $e');
    return getDefaultSobrietyTime();
  }
}

/// Get user's savings statistics (streak, time saved, money saved)
Future<Map<String, dynamic>> getSavingsStats() async {
  try {
    final userId = await SharedPreferencesHelper.getUserId();
    final addictionId = await SharedPreferencesHelper.getAddictionId();
    return await _savingsRepository.getSavings(
      userId: userId,
      addictionId: addictionId,
    );
  } catch (e) {
    print('Error getting savings stats: $e');
    return getDefaultSavingsStats();
  }
}

/// Get the daily quote
Future<Map<String, String>> getDailyQuote() async {
  try {
    return await _quoteRepository.getDailyQuote();
  } catch (e) {
    print('Error getting daily quote: $e');
    return getDefaultQuote();
  }
}

/// Submit daily check-in
Future<bool> submitDailyCheckIn({
  required String mood,
  required double cravingLevel,
  required String journalEntry,
}) async {
  try {
    print(
      'Submitting check-in: Mood: $mood, Craving: $cravingLevel, Journal: $journalEntry',
    );

    final success = await _checkInRepository.submitCheckIn(
      mood: mood,
      cravingLevel: cravingLevel,
      journalEntry: journalEntry,
    );

    return success;
  } catch (e) {
    print('Error submitting check-in: $e');
    return false;
  }
}

/// Get personalized greeting with user name
/// Note: This function doesn't have context, so it returns a key
/// The actual localization should be done in the UI layer
Future<String> getGreetingMessage() async {
  try {
    final hour = DateTime.now().hour;
    String greetingKey;

    if (hour < 12) {
      greetingKey = 'goodMorning';
    } else if (hour < 17) {
      greetingKey = 'goodAfternoon';
    } else {
      greetingKey = 'goodEvening';
    }

    // Get user name from repository
    final userName = await _userRepository.getUserName();
    final displayName = userName ?? 'User';

    // Return a format that can be localized in the UI
    return '$greetingKey|$displayName';
  } catch (e) {
    print('Error getting greeting: $e');
    return 'goodMorning|User';
  }
}

// Default values: fallback if repositories fail

Map<String, String> getDefaultSobrietyTime() {
  return {'days': '0', 'hours': '0', 'minutes': '0'};
}

Map<String, dynamic> getDefaultSavingsStats() {
  return {
    'streak': 0,
    'timeSaved': '0 min',
    'moneySaved': null, // null means addiction doesn't save money
  };
}

Map<String, String> getDefaultQuote() {
  return {
    'text':
        'The greatest glory in living lies not in never falling, but in rising every time we fall.',
    'author': 'Nelson Mandela',
  };
}
