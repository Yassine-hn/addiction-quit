import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/progress_repository.dart';
import '../../data/repositories/settings_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ProgressRepository _progressRepository;
  final SettingsRepository _settingsRepository;
  // We can inject user ID or get it from repository
  final int? _userId; // If null, repo might fetch from prefs or default

  DashboardCubit({
    required ProgressRepository progressRepository,
    required SettingsRepository settingsRepository,
    int? userId,
  })  : _progressRepository = progressRepository,
        _settingsRepository = settingsRepository,
        _userId = userId,
        super(DashboardLoading());

  Future<void> loadDashboardData() async {
    try {
      emit(DashboardLoading());

      // 1. Get userId if not provided (assume repo handles it or we use hardcoded for now if auth is missing)
      // For now, we assume userId is passed or we fetch it. 
      // If _userId is null, we might need to fetch it from UserRepository or SharedPrefs.
      // But let's assume valid session for "Dashboard".
      // Let's rely on getAllAddictions getting passed proper ID or handling it.
      // We'll use a safe fallback or fetch from settings if possible.
      // Actually, let's just get All Addictions first.
      
      // We need a userId.
      int effectiveUserId = _userId ?? 1; // Fallback to 1 for demo if not provided
      
      // 2. Fetch all addictions for the user
      final allAddictions = await _progressRepository.getAllAddictions(effectiveUserId);
      
      if (allAddictions.isEmpty) {
        emit(const DashboardEmpty(message: 'No addictions found. Create one to start!'));
        return;
      }

      // 3. Determine Selected Addiction ID
      int? selectedId = await _settingsRepository.getCurrentAddictionId();
      
      // Verify selected ID still exists in the user's list
      final matchingAddiction = allAddictions.cast<Map<String, dynamic>?>().firstWhere(
        (a) => a!['id'] == selectedId,
        orElse: () => null,
      );

      if (matchingAddiction == null) {
        // Default to first one
        selectedId = allAddictions.first['id'] as int;
        await _settingsRepository.saveCurrentAddictionId(selectedId);
      }

      await _loadAddictionData(selectedId!, allAddictions);

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
        await _loadAddictionData(addictionId, loaded.allAddictions);
      } else {
        // logic if switching from error state?
        loadDashboardData();
      }
    } catch (e) {
      emit(DashboardError('Failed to switch: $e'));
    }
  }

  Future<void> _loadAddictionData(int addictionId, List<Map<String, dynamic>> allAddictions) async {
    final addiction = allAddictions.firstWhere((a) => a['id'] == addictionId);
    final addictionName = addiction['type'] as String; // or 'name' if exists

    // 4. Fetch Details concurrently
    final futures = await Future.wait([
      _progressRepository.getMilestoneProgress(addictionId),
      _progressRepository.getDailySurveyHistory(
        addictionId,
        DateTime.now().subtract(const Duration(days: 14)), // Last 2 weeks for grid? Or month? User said visual history.
        DateTime.now(),
      ),
      _progressRepository.getStreakHistory(addictionId, 30), // 30 days for chart
    ]);

    final milestoneResult = futures[0] as Map<String, dynamic>;
    final dailySurveys = futures[1] as List<Map<String, dynamic>>;
    final streakHistory = futures[2] as List<int>;

    final percentage = milestoneResult['percentage'] as double? ?? 0.0;
    // Map milestone data. If empty, it means no active milestone.
    
    emit(DashboardLoaded(
      selectedAddictionId: addictionId,
      allAddictions: allAddictions,
      milestoneData: milestoneResult,
      milestonePercentage: percentage,
      dailySurveys: dailySurveys,
      streakHistory: streakHistory,
      addictionName: addictionName,
      moodEmoji: '🙂', // Static as requested
    ));
  }
}
