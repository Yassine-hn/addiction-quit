import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/cubits/dashboard_cubit.dart';
import '../../logic/cubits/dashboard_state.dart';
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
                      _buildMilestoneCard(context, state),
                      const SizedBox(height: 24),
                      _buildProgressGridCard(context, state),
                      const SizedBox(height: 16),
                      _buildStreakChartCard(context, state),
                      const SizedBox(height: 16),
                      _buildMoodTrackerCard(context, state),
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

  Widget _buildMilestoneCard(BuildContext context, DashboardLoaded state) {
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
    final milestoneId = milestone?['id'] as int? ?? 0;
    final daysPassed = state.milestoneData['days_passed'] as int? ?? 0;
    final targetDays = state.milestoneData['target_days'] as int? ?? 1;
    final isCompleted = state.milestonePercentage >= 100.0;

    return Column(
      children: [
        Center(
          child: MilestoneCircle(
            percentage: state.milestonePercentage,
            daysPassed: daysPassed,
            targetDays: targetDays,
            title: title,
          ),
        ),
        if (isCompleted) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _handleClaimReward(context, state, milestoneId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.star),
              label: const Text('Claim Reward'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressGridCard(BuildContext context, DashboardLoaded state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProgressGrid(dailySurveys: state.dailySurveys, daysToShow: 30),
      ),
    );
  }

  Widget _buildStreakChartCard(BuildContext context, DashboardLoaded state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreakChart(
          streakHistory: state.streakHistory,
          height: 200,
          lineColor: const Color(0xFF4361EE),
        ),
      ),
    );
  }

  Widget _buildMoodTrackerCard(BuildContext context, DashboardLoaded state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const MoodTracker(),
      ),
    );
  }

  Future<void> _handleClaimReward(
    BuildContext context,
    DashboardLoaded state,
    int milestoneId,
  ) async {
    final success = await context.read<DashboardCubit>().claimMilestoneReward(milestoneId);

    if (success) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Congratulations! Reward claimed!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to claim reward'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showMilestoneSelector(
    BuildContext context,
    DashboardLoaded state,
  ) async {
    final addictionId = state.selectedAddictionId;

    // Validate addictionId
    if (addictionId <= 0) {
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
        onMilestoneSelected: (targetDays, rewardPoints) async {
          try {
            final milestoneRepo = MilestoneRepositoryImpl();
            final l10n = AppLocalizations.of(context)!;
            final title = _getMilestoneTitle(context, targetDays);

            // Check for existing pending milestone
            final existingMilestone = await milestoneRepo.getCurrentMilestone(addictionId);
            if (existingMilestone != null) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You already have an active milestone. Complete or reset it first.'),
                  ),
                );
              }
              return;
            }

            await milestoneRepo.createMilestone(
              addictionId,
              targetDays,
              title,
              rewardPoints,
            );

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
    switch (days) {
      case 1:
        return l10n.milestone1Day;
      case 3:
        return l10n.milestone3Days;
      case 7:
        return l10n.milestone7Days;
      case 14:
        return l10n.milestone14Days;
      case 21:
        return l10n.milestone21Days;
      case 30:
        return l10n.milestone30Days;
      case 40:
        return l10n.milestone40Days;
      case 50:
        return l10n.milestone50Days;
      case 60:
        return l10n.milestone60Days;
      case 75:
        return l10n.milestone75Days;
      case 90:
        return l10n.milestone90Days;
      case 100:
        return l10n.milestone100Days;
      case 120:
        return l10n.milestone120Days;
      case 150:
        return l10n.milestone150Days;
      case 180:
        return l10n.milestone180Days;
      case 200:
        return l10n.milestone200Days;
      case 250:
        return l10n.milestone250Days;
      case 300:
        return l10n.milestone300Days;
      case 365:
        return l10n.milestone365Days;
      default:
        return l10n.daysMilestone(days);
    }
  }
}
