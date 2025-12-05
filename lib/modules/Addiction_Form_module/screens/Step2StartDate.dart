// New Step2StartDate.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Step3PerWeek.dart';
import '../data/Cubit/UserInfoCubit.dart';
import '../widgets/SectionTitle.dart';
import '../widgets/ValidationButton.dart';
import '../widgets/WheelDatePicker.dart';

class Step2StartDate extends StatefulWidget {
  const Step2StartDate({super.key});

  @override
  State<Step2StartDate> createState() => _Step2StartDateState();
}

class _Step2StartDateState extends State<Step2StartDate> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Load initial date from cubit if exists
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    if (cubit.state.startDate != null) {
      _selectedDate = cubit.state.startDate;
    } else {
      // Default to today
      _selectedDate = DateTime.now();
    }
  }

  void _handleContinue() {
    if (_selectedDate != null) {
      context.read<UserInfoCubit>().updateStartDate(_selectedDate!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<UserInfoCubit>(),
            child: Step3PerWeek(),
          ),
        ),
      );
    }
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
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
                title: 'When did your journey begin?',
                subtitle: 'Starting Date',
              ),
              const SizedBox(height: 40),

              // Selected Date Preview
              if (_selectedDate != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Color.fromARGB(255, 0, 9, 180),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_selectedDate!),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Wheel Date Picker
              Expanded(
                child: WheelDatePicker(
                  initialDate: _selectedDate,
                  onDateChanged: _onDateChanged,
                  minDate: DateTime(1900),
                  maxDate: DateTime.now(),
                ),
              ),
              const SizedBox(height: 24),

              // Continue Button
              ValidationButton(
                label: 'Continue',
                onPressed: _handleContinue,
                enabled: _selectedDate != null,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
