import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/milestone_repository.dart';
import '../../data/repositories/daily_survey_repository.dart';
import '../../data/repositories/addiction_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final MilestoneRepository _milestoneRepository;
  final DailySurveyRepository _dailySurveyRepository;
  final AddictionRepository _addictionRepository;
  final SettingsRepository _settingsRepository;

  DashboardCubit({
    required MilestoneRepository milestoneRepository,
    required DailySurveyRepository dailySurveyRepository,
    required AddictionRepository addictionRepository,
    required SettingsRepository settingsRepository,
  }) : _milestoneRepository = milestoneRepository,
       _dailySurveyRepository = dailySurveyRepository,
       _addictionRepository = addictionRepository,
       _settingsRepository = settingsRepository,
       super(DashboardLoading());

  Future<void> loadDashboardData() async {
    try {
      emit(DashboardLoading());

      // 1. Get userId and addictionId from SharedPreferences
      final userId = await SharedPreferencesHelper.getUserId();
      final addictionId = await SharedPreferencesHelper.getAddictionId();

      if (userId == null) {
        emit(const DashboardError('No user ID found. Please login.'));
        return;
      }

      // 2. Fetch all addictions for the user
      final allAddictions = await _addictionRepository.getAllUserAddictions(
        userId,
      );

      if (allAddictions.isEmpty) {
        emit(
          const DashboardEmpty(
            message: 'No addictions found. Create one to start!',
          ),
        );
        return;
      }

      // 3. Determine Selected Addiction ID
      int? selectedId = addictionId;

      // Verify selected ID still exists in the user's list
      final matchingAddiction = allAddictions.firstWhere(
        (a) => a['id'] == selectedId,
        orElse: () => <String, dynamic>{},
      );

      if (matchingAddiction.isEmpty) {
        // Default to first one
        selectedId = allAddictions.first['id'] as int;
        await _settingsRepository.saveCurrentAddictionId(selectedId);
      }

      await _loadAddictionData(userId, selectedId!, allAddictions);
    } catch (e) {
      emit(DashboardError('Failed to load dashboard: $e'));
    }
  }

  Future<void> switchAddiction(int addictionId) async {
    try {
      if (state is DashboardLoaded) {
        final loaded = state as DashboardLoaded;
        if (loaded.selectedAddictionId == addictionId) return;

        emit(DashboardLoading());
        await _settingsRepository.saveCurrentAddictionId(addictionId);

        final userId = await SharedPreferencesHelper.getUserId();
        if (userId == null) {
          emit(const DashboardError('No user ID found.'));
          return;
        }

        await _loadAddictionData(userId, addictionId, loaded.allAddictions);
      } else {
        loadDashboardData();
      }
    } catch (e) {
      emit(DashboardError('Failed to switch: $e'));
    }
  }

  Future<void> _loadAddictionData(
    int userId,
    int addictionId,
    List<Map<String, dynamic>> allAddictions,
  ) async {
    final addiction = allAddictions.firstWhere((a) => a['id'] == addictionId);
    final addictionName = addiction['type'] as String;

    // Check and mark completed milestones first
    await _milestoneRepository.checkAndMarkCompletedMilestones(addictionId);

    // Fetch Details concurrently
    final futures = await Future.wait([
      _milestoneRepository.calculateMilestoneProgress(userId, addictionId),
      _milestoneRepository.getCurrentMilestone(addictionId),
      _dailySurveyRepository.getLast30Days(userId, addictionId),
      _addictionRepository.getStreakHistory(userId, addictionId, 30),
    ]);

    final milestonePercentage = futures[0] as double;
    final currentMilestone = futures[1] as Map<String, dynamic>?;
    final dailySurveys = futures[2] as List<Map<String, dynamic>>;
    final streakHistory = futures[3] as List<Map<String, dynamic>>;

    Map<String, dynamic> milestoneData = {};
    int daysPassed = 0;
    int targetDays = 0;

    if (currentMilestone != null && milestonePercentage >= 0) {
      final createdAtStr = currentMilestone['created_at'] as String;
      final createdAt = DateTime.parse(createdAtStr);
      final now = DateTime.now();
      daysPassed = now.difference(createdAt).inDays;
      targetDays = currentMilestone['target_value'] as int;

      milestoneData = {
        'milestone': currentMilestone,
        'days_passed': daysPassed,
        'target_days': targetDays,
      };
    }

    emit(
      DashboardLoaded(
        selectedAddictionId: addictionId,
        allAddictions: allAddictions,
        milestoneData: milestoneData,
        milestonePercentage: milestonePercentage >= 0
            ? milestonePercentage
            : 0.0,
        dailySurveys: dailySurveys,
        streakHistory: streakHistory,
        addictionName: addictionName,
        moodEmoji: '🙂', // Static as requested
      ),
    );
  }
}
