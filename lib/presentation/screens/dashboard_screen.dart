import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/cubit/dashboard_cubit.dart';
import '../../logic/cubit/dashboard_state.dart';
import '../../data/repositories/milestone_repository.dart';
import '../../data/repositories/daily_survey_repository.dart';
import '../../data/repositories/addiction_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../widgets/milestone_circle.dart';
import '../widgets/progress_grid.dart';
import '../widgets/streak_chart_painter.dart';
import '../widgets/mood_tracker.dart';
import '../widgets/useful_widgets.dart';
import '../widgets/milestone_selector.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        milestoneRepository: MilestoneRepositoryImpl(),
        dailySurveyRepository: DailySurveyRepositoryImpl(),
        addictionRepository: AddictionRepositoryImpl(),
        settingsRepository: SettingsRepository(),
      )..loadDashboardData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.dashboard),
          backgroundColor: const Color(0xFF4361EE),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF4361EE)),
              );
            } else if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DashboardCubit>().loadDashboardData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4361EE),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              );
            } else if (state is DashboardEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Navigation to create addiction screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Start New Milestone feature coming soon!',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4361EE),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Start New Milestone'),
                    ),
                  ],
                ),
              );
            } else if (state is DashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<DashboardCubit>().loadDashboardData(),
                color: const Color(0xFF4361EE),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ROW 1: MILESTONE PROGRESS CIRCLE
                      _buildMilestoneRow(context, state),
                      const SizedBox(height: 24),

                      // ROW 2: THREE EQUAL-WIDTH CARDS
                      _buildThreeCardsRow(context, state),
                      const SizedBox(height: 80), // Space for bottom nav
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: const CustomBottomNavBar(activeIndex: 1),
      ),
    );
  }

  Widget _buildMilestoneRow(BuildContext context, DashboardLoaded state) {
    final hasMilestone = state.milestoneData.isNotEmpty;

    if (!hasMilestone) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.flag_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.noActiveMilestone,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showMilestoneSelector(context, state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4361EE),
                  foregroundColor: Colors.white,
                ),
                child: Text(AppLocalizations.of(context)!.startNewMilestone),
              ),
            ],
          ),
        ),
      );
    }

    final milestone = state.milestoneData['milestone'] as Map<String, dynamic>?;
    final title = milestone?['title'] as String? ?? 'Milestone';
    final daysPassed = state.milestoneData['days_passed'] as int? ?? 0;
    final targetDays = state.milestoneData['target_days'] as int? ?? 1;

    return Center(
      child: MilestoneCircle(
        percentage: state.milestonePercentage,
        daysPassed: daysPassed,
        targetDays: targetDays,
        title: title,
      ),
    );
  }

  Widget _buildThreeCardsRow(BuildContext context, DashboardLoaded state) {
    return Column(
      children: [
        // CARD 1: DAILY SURVEY HISTORY
        ProgressGrid(dailySurveys: state.dailySurveys, daysToShow: 30),
        const SizedBox(height: 16),
        // CARD 2: STREAK CHART
        StreakChart(
          streakHistory: state.streakHistory,
          height: 200,
          lineColor: const Color(0xFF4361EE),
        ),
        const SizedBox(height: 16),
        // CARD 3: MOOD TRACKER
        const MoodTracker(),
      ],
    );
  }

  Future<void> _showMilestoneSelector(
    BuildContext context,
    DashboardLoaded state,
  ) async {
    final userId = await SharedPreferencesHelper.getUserId();
    final addictionId = state.selectedAddictionId;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.unableToCreateMilestone),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => MilestoneSelector(
        onMilestoneSelected: (targetDays) async {
          try {
            final milestoneRepo = MilestoneRepositoryImpl();
            final l10n = AppLocalizations.of(context)!;
            final title = _getMilestoneTitle(context, targetDays);
            await milestoneRepo.createMilestone(addictionId, targetDays, title);

            // Reload dashboard data
            if (context.mounted) {
              context.read<DashboardCubit>().loadDashboardData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.milestoneStarted(title))),
              );
            }
          } catch (e) {
            if (context.mounted) {
              final l10n = AppLocalizations.of(context)!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.errorCreatingMilestone(e.toString())),
                ),
              );
            }
          }
        },
      ),
    );
  }

  String _getMilestoneTitle(BuildContext context, int days) {
    final l10n = AppLocalizations.of(context)!;
    if (days == 1) return l10n.oneDayMilestone;
    if (days == 7) return l10n.oneWeekMilestone;
    if (days == 14) return l10n.twoWeeksMilestone;
    if (days == 30) return l10n.oneMonthMilestone;
    if (days == 60) return l10n.twoMonthsMilestone;
    if (days == 90) return l10n.threeMonthsMilestone;
    if (days == 180) return l10n.sixMonthsMilestone;
    if (days == 365) return l10n.oneYearMilestone;
    return l10n.daysMilestone(days);
  }
}
