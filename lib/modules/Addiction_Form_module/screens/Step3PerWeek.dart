// Step3PerWeek.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import '../widgets/SectionTitle.dart';
import '../widgets/ValidationButton.dart';
import '../widgets/FrequencyOption.dart';
import 'Step4PerDay.dart';

class Step3PerWeek extends StatefulWidget {
  const Step3PerWeek({super.key});

  @override
  State<Step3PerWeek> createState() => _Step3PerWeekState();
}

class _Step3PerWeekState extends State<Step3PerWeek> {
  int? _selectedValue;

  @override
  void initState() {
    super.initState();
    // Load initial value from cubit if exists
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final currentValue = cubit.state.consumptionDayPerWeek;

    if (currentValue != null) {
      _selectedValue = currentValue;
    }
  }

  void _handleContinue() {
    print(
      "====================ENTERED HANDLE CONTINUE SCREEN 3 ====================",
    );
    if (_selectedValue != null) {
      context.read<UserInfoCubit>().updateConsumptionDayPerWeek(
        _selectedValue!,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<UserInfoCubit>(),
            child: Step4PerDay(),
          ),
        ),
      );
    }
  }

  void _selectValue(int? value) {
    setState(() {
      _selectedValue = value;
    });
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              const SectionTitle(
                title: 'How often do you fall into your addiction per week?',
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 40),

              // Irregular Option
              FrequencyOption(
                text: 'Irregularly',
                isSelected: _selectedValue == -1,
                onTap: () => _selectValue(-1),
                isIrregular: true,
              ),
              const SizedBox(height: 24),

              // Days Grid
              Expanded(child: _buildDaysGrid()),
              const SizedBox(height: 24),

              // Continue Button
              ValidationButton(
                label: 'Continue',
                onPressed: () =>
                    _selectedValue != null ? _handleContinue() : null,
                enabled: _selectedValue != null,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaysGrid() {
    const days = [1, 2, 3, 4, 5, 6, 7];

    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: days.map((day) {
        return FrequencyOption(
          text: day.toString(),
          isSelected: _selectedValue == day,
          onTap: () => _selectValue(day),
        );
      }).toList(),
    );
  }
}
