// selection_step_screen.dart - Reusable component for both Step6 and Step7
import 'package:flutter/material.dart';
import '../widgets/ValidationButton.dart';
import '../models/SelectionStepConfif.dart';

class SelectionStepScreen extends StatefulWidget {
  final SelectionStepConfig config;
  final Function(String) onValueSelected;

  const SelectionStepScreen({
    super.key,
    required this.config,
    required this.onValueSelected,
  });

  @override
  State<SelectionStepScreen> createState() => _SelectionStepScreenState();
}

class _SelectionStepScreenState extends State<SelectionStepScreen> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize with existing value if any
    if (widget.config.selectedValue != null) {
      _selectedValue = widget.config.selectedValue;
    }
  }

  void _handleContinue() {
    if (_selectedValue != null) {
      widget.onValueSelected(_selectedValue!);
    }
  }

  bool get _isValid => _selectedValue != null;

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
              // Header with optional screen title
              if (widget.config.screenTitle != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      widget.config.screenTitle!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),

              // Main Question
              Text(
                widget.config.mainQuestion,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 9, 180),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 40),

              // Options List
              Column(
                children: widget.config.options.map((option) {
                  return _buildOptionTile(option);
                }).toList(),
              ),

              const SizedBox(height: 40),

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

  Widget _buildOptionTile(String option) {
    final isSelected = _selectedValue == option;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedValue = option;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF0F4FF) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color.fromARGB(255, 0, 9, 180)
                    : const Color(0xFFEEEEEE),
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          0,
                          9,
                          180,
                        ).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color.fromARGB(255, 0, 9, 180)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color.fromARGB(255, 0, 9, 180)
                          : const Color(0xFFDDDDDD),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? const Color.fromARGB(255, 0, 9, 180)
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
