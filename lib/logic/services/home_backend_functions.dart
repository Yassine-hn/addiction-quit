// Fonctions to implement for home_screen backen
// for now they only return static values

///get of sobriety of user
Future<Map<String, String>> getSobrietyTime() async {
  // TODO: implement API call to get sobriety time
  // Example API: {"days": "42", "hours": "11", "minutes": "23"}
  return {'days': '42', 'hours': '11', 'minutes': '23'};
}

/// get user's statistics
Future<Map<String, dynamic>> getUserStats() async {
  // TODO
  return {'streak': 42, 'moneySaved': '\$210', 'milestone': 8};
}

/// get the daily citation
Future<Map<String, String>> getDailyQuote() async {
  // TODO
  return {
    'text':
        'The greatest glory in living lies not in never falling, but in rising every time we fall.',
    'author': 'Nelson Mandela',
  };
}

/// submit daily check-in
Future<bool> submitDailyCheckIn({
  required String mood,
  required double cravingLevel,
  required String journalEntry,
}) async {
  // TODO: API call to submit the check-in
  print(
    'Submitting check-in: Mood: $mood, Craving: $cravingLevel, Journal: $journalEntry',
  );

  // only for simulation
  await Future.delayed(const Duration(seconds: 1));

  return true; // true if success
}

/// personalized greeting
String getGreetingMessage() {
  // TODO: implement HOUR and user NAME logic
  final hour = DateTime.now().hour;
  String greeting;

  if (hour < 12) {
    greeting = 'Good morning';
  } else if (hour < 17) {
    greeting = 'Good afternoon';
  } else {
    greeting = 'Good evening';
  }

  // TODO: get name
  return '$greeting, Alex';
}

// default : fallback if API fails

Map<String, String> getDefaultSobrietyTime() {
  return {'days': '42', 'hours': '11', 'minutes': '23'};
}

Map<String, dynamic> getDefaultStats() {
  return {'streak': 42, 'moneySaved': '\$210', 'milestone': 8};
}

Map<String, String> getDefaultQuote() {
  return {
    'text':
        'The greatest glory in living lies not in never falling, but in rising every time we fall.',
    'author': 'Nelson Mandela',
  };
}
