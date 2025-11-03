// dashboard_screen.dart
import 'package:flutter/material.dart';
import '../models/progress_data.dart';
import '../repositories/progress_repository.dart';
import '../widgets/useful_widgets.dart';



class DashboardScreen extends StatefulWidget {
  final ProgressRepository repository;

  const DashboardScreen({
    Key? key,
    required this.repository,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ProgressData? _progressData;
  WeeklyProgress? _weeklyProgress;
  List<Goal>? _goals;
  bool _isLoading = true;
  String _selectedTab = 'Progress';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final results = await Future.wait([
        widget.repository.getProgressData(),
        widget.repository.getWeeklyProgress(),
        widget.repository.getAvailableGoals(),
      ]);

      setState(() {
        _progressData = results[0] as ProgressData;
        _weeklyProgress = results[1] as WeeklyProgress;
        _goals = results[2] as List<Goal>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'My Progress',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressCircle(),
                  const SizedBox(height: 30),
                  _buildJourneyTabs(),
                  const SizedBox(height: 20),
                  _buildMonthlyProgress(),
                  const SizedBox(height: 30),
                  _buildGoalsSection(),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomNavBar(
        activeIndex: 1,
      ), // CustomBottomNavBar
    );
  }

  Widget _buildProgressCircle() {
    if (_progressData == null) return const SizedBox();

    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[300],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_progressData!.percentage.toInt()}%',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_progressData!.daysStreak} Days Sober',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJourneyTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Journey',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildTab('Progress'),
            const SizedBox(width: 16),
            _buildTab('Streaks'),
            const SizedBox(width: 16),
            _buildTab('Mood'),
          ],
        ),
      ],
    );
  }

  Widget _buildTab(String title) {
    final isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue[700] : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyProgress() {
    if (_weeklyProgress == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Monthly Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _weeklyProgress!.changePercentage,
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _weeklyProgress!.days.map((day) {
              return _buildProgressBar(day);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(DayProgress day) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: day.value * 1.5,
              decoration: BoxDecoration(
                color: day.color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              day.day,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection() {
    if (_goals == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select a Goal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: _goals!.length,
          itemBuilder: (context, index) {
            return _buildGoalCard(_goals![index]);
          },
        ),
      ],
    );
  }

  Widget _buildGoalCard(Goal goal) {
    return GestureDetector(
      onTap: () async {
        await widget.repository.selectGoal(goal.title);
        _loadData();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: goal.isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: goal.isSelected ? Colors.blue[300]! : Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              goal.icon,
              size: 32,
              color: goal.isSelected ? Colors.blue[700] : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              goal.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: goal.isSelected ? FontWeight.w600 : FontWeight.normal,
                color: goal.isSelected ? Colors.blue[700] : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

