// Step3PerWeek.dart - Alternative version with Wrap
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
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final currentValue = cubit.state.consumptionDayPerWeek;

    if (currentValue != null) {
      _selectedValue = currentValue;
    }
  }

  void _handleContinue() {
    if (_selectedValue != null) {
      context.read<UserInfoCubit>().updateConsumptionDayPerWeek(
        _selectedValue!,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<UserInfoCubit>(),
            child: const Step4PerDay(),
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
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

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
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? 32 : 24.0,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                Text(
                  'How often do you fall into your addiction per week?',
                  style: TextStyle(
                    fontSize: isLandscape ? 26 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),

                // Irregular Option
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: FrequencyOption(
                    text: 'Irregularly',
                    isSelected: _selectedValue == -1,
                    onTap: () => _selectValue(-1),
                    isIrregular: true,
                  ),
                ),

                // Days Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Select number of days:',
                    style: TextStyle(
                      fontSize: isLandscape ? 16 : 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Days Grid using Wrap
                _buildDaysWrap(isLandscape),

                const SizedBox(height: 40),

                // Continue Button
                Container(
                  margin: EdgeInsets.only(
                    top: 24,
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                  ),
                  child: ValidationButton(
                    label: 'Continue',
                    onPressed: () =>
                        _selectedValue != null ? _handleContinue() : null,
                    enabled: _selectedValue != null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaysWrap(bool isLandscape) {
    const days = [1, 2, 3, 4, 5, 6, 7];

    return Wrap(
      spacing: isLandscape ? 12 : 16,
      runSpacing: isLandscape ? 12 : 16,
      alignment: WrapAlignment.start,
      children: days.map((day) {
        // Calculate item width based on screen size and orientation
        final itemWidth =
            (MediaQuery.of(context).size.width -
                (isLandscape ? 64 : 48) - // subtract horizontal padding
                (isLandscape ? 5 * 12 : 3 * 16)) / // subtract spacing
            (isLandscape ? 7 : 4); // divide by number of items per row

        return SizedBox(
          width: itemWidth,
          height: itemWidth, // Make it square
          child: FrequencyOption(
            text: day.toString(),
            isSelected: _selectedValue == day,
            onTap: () => _selectValue(day),
          ),
        );
      }).toList(),
    );
  }
}
