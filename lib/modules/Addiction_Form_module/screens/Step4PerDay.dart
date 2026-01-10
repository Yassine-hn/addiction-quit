// Step4PerDay.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import '../widgets/SectionTitle.dart';
import '../widgets/ValidationButton.dart';
import '../widgets/NumberInputField.dart';
import '../screens/Step5Objectives.dart';
import '../../../l10n/app_localizations.dart';

class Step4PerDay extends StatefulWidget {
  const Step4PerDay({super.key});

  @override
  State<Step4PerDay> createState() => _Step4PerDayState();
}

class _Step4PerDayState extends State<Step4PerDay> {
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocusNode = FocusNode();
  bool _isInputValid = false;

  // For UI selection (doesn't affect business logic)
  String? _selectedOption;

  @override
  void initState() {
    super.initState();

    // Load existing value from cubit
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final currentValue = cubit.state.consumptionPerDay;

    if (currentValue != null) {
      _numberController.text = currentValue.toString();
      _validateInput(currentValue.toString());
    }

    // Auto-select custom option if we have a value
    if (_numberController.text.isNotEmpty) {
      _selectedOption = 'custom';
    }
  }

  void _validateInput(String value) {
    final number = int.tryParse(value);
    setState(() {
      _isInputValid = number != null && number > 0;
    });
  }

  void _handleOptionSelected(String option) {
    setState(() {
      _selectedOption = option;

      // Auto-fill suggestions based on selection
      if (option == 'option1') {
        // When I feel deprived
        _numberController.text = '1';
        _validateInput('1');
      } else if (option == 'option2') {
        // Sometimes
        _numberController.text = '3';
        _validateInput('3');
      } else if (option == 'option3') {
        // Often
        _numberController.text = '5';
        _validateInput('5');
      } else if (option == 'custom') {
        // Focus on textfield for custom input
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _numberFocusNode.requestFocus();
        });
      }
    });
  }

  void _handleContinue() {
    if (_isInputValid) {
      final number = int.tryParse(_numberController.text);
      if (number != null) {
        context.read<UserInfoCubit>().updateConsumptionPerDay(number);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<UserInfoCubit>(),
              child: Step5Objectives(),
            ),
          ),
        );
      }
    }
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
              const SizedBox(height: 8),

              SectionTitle(
                title:
                    AppLocalizations.of(context)!.howManyTimesPerDay,
              ),
              const SizedBox(height: 32),

              // Quick Selection Options
              Text(
                AppLocalizations.of(context)!.quickSelection,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildQuickOption(AppLocalizations.of(context)!.whenIFeelDeprived, 'option1'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickOption(AppLocalizations.of(context)!.sometimes, 'option2')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickOption(AppLocalizations.of(context)!.often, 'option3')),
                ],
              ),
              const SizedBox(height: 24),

              // Custom Input
              NumberInputField(
                label: AppLocalizations.of(context)!.orEnterSpecificNumber,
                hintText: AppLocalizations.of(context)!.egFive,
                controller: _numberController,
                onChanged: (value) {
                  _validateInput(value);
                  // When user types, automatically select custom option
                  if (value.isNotEmpty) {
                    setState(() {
                      _selectedOption = 'custom';
                    });
                  }
                },
                autoFocus: _selectedOption == 'custom',
              ),
              const SizedBox(height: 8),

              // Help Text
              const Text(
                'Enter an average number if you are not sure.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 40),

              // Continue Button
              ValidationButton(
                label: 'Continue',
                onPressed: () => _isInputValid ? _handleContinue() : null,
                enabled: _isInputValid,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickOption(String title, String option) {
    final isSelected = _selectedOption == option;

    return GestureDetector(
      onTap: () => _handleOptionSelected(option),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8E8FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 0, 9, 180)
                : const Color(0xFFEEEEEE),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color.fromARGB(255, 0, 9, 180)
                    : Colors.black87,
              ),
            ),
            if (isSelected) const SizedBox(height: 4),
            if (isSelected)
              Text(
                option == 'option1'
                    ? '≈1'
                    : option == 'option2'
                    ? '≈3'
                    : '≈5',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
