// daily_survey_repository.dart
import '../databases/db_helper.dart';
import '../databases/tables/daily_surveys_table.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

abstract class DailySurveyRepository {
  /// Get last 30 days of daily surveys
  Future<List<Map<String, dynamic>>> getLast30Days(int userId, int addictionId);
}

class DailySurveyRepositoryImpl implements DailySurveyRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Map<String, dynamic>>> getLast30Days(
    int userId,
    int addictionId,
  ) async {
    try {
      final db = await _dbHelper.database;
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 30));

      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = now.toIso8601String().split('T')[0];

      final surveys = await DailySurveysTable.getByDateRange(
        db,
        addictionId,
        startStr,
        endStr,
      );

      // Map 'slipped' field to 'slip' for consistency
      return surveys.map((survey) {
        final mapped = Map<String, dynamic>.from(survey);
        // Map 'slipped' (int) to 'slip' (bool) if needed
        if (mapped.containsKey('slipped')) {
          mapped['slip'] = (mapped['slipped'] as int? ?? 0) == 1;
        }
        return mapped;
      }).toList();
    } catch (e) {
      print('Error getting last 30 days surveys: $e');
      return [];
    }
  }
}
