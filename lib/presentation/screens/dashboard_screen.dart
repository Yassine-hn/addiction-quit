import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/dashboard_cubit.dart';
import '../../logic/cubit/dashboard_state.dart';
import '../../data/repositories/progress_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/utils/database_seeder.dart';
import '../widgets/milestone_circle.dart';
import '../widgets/progress_grid.dart';
import '../widgets/streak_chart_painter.dart';

class DashboardScreen extends StatelessWidget {
  final ProgressRepository repository;

  const DashboardScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        progressRepository: repository,
        settingsRepository: SettingsRepository(), 
      )..loadDashboardData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            // Seeder Button (Temporary)
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              tooltip: 'Seed Data',
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                try {
                   // Dynamic import to avoid polluting imports if we remove it later? 
                   // No, just import it at top.
                   // Actually, we need to add the import to the file first.
                   // So I should do a bigger replace or just assume I'll fix imports.
                   // Let's use the seeder.
                   await DatabaseSeeder().seed();
                   if (context.mounted) {
                     context.read<DashboardCubit>().loadDashboardData();
                     scaffoldMessenger.showSnackBar(
                       const SnackBar(content: Text('Database seeded successfully!'))
                     );
                   }
                } catch (e) {
                   if (context.mounted) {
                     scaffoldMessenger.showSnackBar(
                       SnackBar(content: Text('Error seeding: $e'))
                     );
                   }
                }
              },
            ),
            // Addiction Selector
            BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoaded) {
                  return PopupMenuButton<int>(
                    onSelected: (id) {
                      context.read<DashboardCubit>().switchAddiction(id);
                    },
                    icon: const Icon(Icons.swap_horiz),
                    itemBuilder: (context) {
                      return state.allAddictions.map((addiction) {
                        return PopupMenuItem<int>(
                          value: addiction['id'] as int,
                          child: Text(addiction['type'] as String),
                        );
                      }).toList();
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardError) {
              return Center(child: Text(state.message));
            } else if (state is DashboardEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                         // Fallback for demo
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Create Addiction feature coming soon!'))
                         );
                      },
                      child: const Text('Start New Journey'),
                    )
                  ],
                ),
              );
            } else if (state is DashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<DashboardCubit>().loadDashboardData(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Mood
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Current Focus: ${state.addictionName}',
                              style: Theme.of(context).textTheme.headlineSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            state.moodEmoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Milestone Progress
                      Center(
                        child: state.milestoneData.isNotEmpty
                        ? MilestoneCircle(
                            percentage: state.milestonePercentage,
                            daysPassed: state.milestoneData['days_passed'] ?? 0,
                            targetDays: state.milestoneData['target_days'] ?? 10,
                            title: state.milestoneData['milestone']['title'] ?? 'Milestone',
                          )
                        : Column(
                            children: [
                              const Text('No Active Milestone'),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Start Milestone feature coming soon...'))
                                  );
                                },
                                child: const Text('Start Milestone'),
                              )
                            ],
                          ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Progress Grid
                      Text('Daily Progress', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Center(
                        child: ProgressGrid(
                          dailySurveys: state.dailySurveys,
                          daysToShow: 14,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Streak Chart
                      Text('Streak History (30 Days)', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(12),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black.withOpacity(0.05),
                               blurRadius: 10,
                               offset: const Offset(0, 4),
                             )
                           ]
                        ),
                        child: StreakChart(
                          streakHistory: state.streakHistory,
                          height: 150,
                          lineColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
