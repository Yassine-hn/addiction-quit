// Step5Objectives.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import '../widgets/SectionTitle.dart';
import '../widgets/ValidationButton.dart';
import '../widgets/SearchBarWidget.dart';
import '../widgets/MultiSelectChip.dart';
import '../widgets/MotivationTextField.dart';
import '../data/Repositories/GoalsRepo.dart';
import 'Step6Importance.dart';

class Step5Objectives extends StatefulWidget {
  const Step5Objectives({super.key});

  @override
  State<Step5Objectives> createState() => _Step5ObjectivesState();
}

class _Step5ObjectivesState extends State<Step5Objectives> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _motivationController = TextEditingController();
  final GoalsRepo _goalsRepo = GoalsRepo();

  List<String> _selectedGoals = [];
  List<String> _filteredGoals = [];

  @override
  void initState() {
    super.initState();

    // Load existing data from cubit
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final state = cubit.state;

    // Load selected goals
    if (state.goals != null) {
      _selectedGoals = List.from(state.goals!);
    }

    // Load main motivation
    if (state.mainMotivation != null) {
      _motivationController.text = state.mainMotivation!;
    }

    // Initialize filtered goals
    _filteredGoals = _goalsRepo.data;
  }

  void _handleContinue() {
    if (_isValid) {
      final cubit = context.read<UserInfoCubit>();

      // Update goals (multiple selection)
      cubit.updateGoals(_selectedGoals);

      // Update main motivation (single text)
      cubit.updateMainMotivation(_motivationController.text.trim());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<UserInfoCubit>(),
            child: Step6Importance(),
          ),
        ),
      );
    }
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
    });
  }

  void _filterGoals(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredGoals = _goalsRepo.data;
      } else {
        _filteredGoals = _goalsRepo.searchGoals(query);
      }
    });
  }

  bool get _isValid {
    return _selectedGoals.isNotEmpty &&
        _motivationController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SectionTitle(title: 'Main Goals'),
              const SizedBox(height: 8),
              const Text(
                'What are your main goals?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),

              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: _filterGoals,
                hintText: 'Search for a goal...',
              ),
              const SizedBox(height: 20),

              // Goals Selection Section
              _buildGoalsSelectionSection(),
              const SizedBox(height: 32),

              // Divider
              const Divider(color: Color(0xFFEEEEEE), thickness: 1, height: 40),
              const SizedBox(height: 8),

              // Motivation Input Section
              _buildMotivationSection(),
              const SizedBox(height: 40),

              // Validation Status
              if (!_isValid) _buildValidationMessage(),

              // Continue Button
              ValidationButton(
                label: 'Continue',
                onPressed: () => _isValid ? _handleContinue() : null,
                enabled: _isValid,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selection Counter
        Row(
          children: [
            const Text(
              'Select one or more goals:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Text(
              '${_selectedGoals.length} selected',
              style: TextStyle(
                fontSize: 14,
                color: _selectedGoals.isNotEmpty
                    ? const Color.fromARGB(255, 0, 9, 180)
                    : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Goals Grid
        if (_filteredGoals.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No goals found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        else
          Wrap(
            children: _filteredGoals.map((goal) {
              return MultiSelectChip(
                text: goal,
                isSelected: _selectedGoals.contains(goal),
                onTap: () => _toggleGoal(goal),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildMotivationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MotivationTextField(
          label: 'Feel free to express it with your own words',
          hintText: 'My personal goal is...',
          controller: _motivationController,
          onChanged: (value) => setState(() {}),
          maxLines: 4,
        ),
        const SizedBox(height: 8),
        const Text(
          'Describe your main motivation in your own words',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildValidationMessage() {
    final List<String> missing = [];

    if (_selectedGoals.isEmpty) missing.add('select at least one goal');
    if (_motivationController.text.trim().isEmpty)
      missing.add('describe your motivation');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEEBA), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF856404), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Please ${missing.join(' and ')}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF856404)),
            ),
          ),
        ],
      ),
    );
  }
}
