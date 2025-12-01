// profile_backend_functions.dart
import '../../data/repositories/profile_repository.dart';

final ProfileRepository _profileRepository = ProfileRepositoryImpl();

// Get user profile data
Future<Map<String, String>> getUserProfile() async {
  try {
    return await _profileRepository.fetchUserProfile();
  } catch (e) {
    return getDefaultUserProfile();
  }
}

// Get user achievements
Future<List<Map<String, dynamic>>> getUserAchievements() async {
  try {
    return await _profileRepository.fetchUserAchievements();
  } catch (e) {
    return getDefaultAchievements();
  }
}

// Get user journeys
Future<List<Map<String, dynamic>>> getUserJourneys() async {
  try {
    return await _profileRepository.fetchUserJourneys();
  } catch (e) {
    return getDefaultJourneys();
  }
}

// Update user profile
Future<bool> updateUserProfile({
  required String name,
  required String tagline,
}) async {
  try {
    return await _profileRepository.updateProfile(name: name, tagline: tagline);
  } catch (e) {
    return false;
  }
}

// Default/fallback data
Map<String, String> getDefaultUserProfile() {
  return {'name': 'Alex J.', 'tagline': 'Your journey to a better you'};
}

List<Map<String, dynamic>> getDefaultAchievements() {
  return [
    {
      'icon': 'coffee',
      'title': '30 Days Caffeine-Free',
      'date': 'Awarded on May 15, 2024',
    },
    {
      'icon': 'phone',
      'title': 'First Week Social Media Break',
      'date': 'Awarded on Apr 27, 2024',
    },
  ];
}

List<Map<String, dynamic>> getDefaultJourneys() {
  return [
    {
      'icon': 'coffee',
      'title': 'Caffeine',
      'subtitle': 'Time Sober',
      'days': '15 Days',
    },
    {
      'icon': 'phone',
      'title': 'Social Media',
      'subtitle': 'Time Sober',
      'days': '3 Days',
    },
    {
      'icon': 'smoke',
      'title': 'Vaping',
      'subtitle': 'Time Sober',
      'days': '42 Days',
    },
  ];
}
