// Step9ReviewHour.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import '../widgets/ValidationButton.dart';
import 'StepFinal.dart';
import '../../../l10n/app_localizations.dart';

class Step9ReviewHour extends StatefulWidget {
  const Step9ReviewHour({super.key});

  @override
  State<Step9ReviewHour> createState() => _Step9ReviewHourState();
}

class _Step9ReviewHourState extends State<Step9ReviewHour> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  int _selectedHour = 14;
  int _selectedMinute = 0;

  @override
  void initState() {
    super.initState();

    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final currentValue = cubit.state.dailyReview;

    if (currentValue != null) {
      _selectedHour = currentValue.hour;
      _selectedMinute = currentValue.minute;
    }

    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinute,
    );
  }

  void _handleContinue() {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedHour,
      _selectedMinute,
    );

    context.read<UserInfoCubit>().updateDailyReview(selectedDateTime);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<UserInfoCubit>(),
          child: StepFinal(),
        ),
      ),
    );
  }

  String _formatTime() {
    final hour = _selectedHour;
    final minute = _selectedMinute.toString().padLeft(2, '0');

    if (hour == 0) return '12:$minute AM';
    if (hour < 12) return '$hour:$minute AM';
    if (hour == 12) return '12:$minute PM';
    return '${hour - 12}:$minute PM';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dailyReviewTime,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.whenWouldYouLikeDailyReview,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50.withOpacity(.25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.chooseTimeForReflection,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Selected time display
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(),
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _selectedHour < 12 ? AppLocalizations.of(context)!.morning : AppLocalizations.of(context)!.afternoon,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Wheel pickers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  AppLocalizations.of(context)!.hour,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Expanded(
                                  child: ListWheelScrollView.useDelegate(
                                    controller: _hourController,
                                    itemExtent: 42,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        _selectedHour = index;
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            return Center(
                                              child: Text(
                                                index.toString().padLeft(
                                                  2,
                                                  '0',
                                                ),
                                                style: TextStyle(
                                                  fontSize:
                                                      index == _selectedHour
                                                      ? 24
                                                      : 18,
                                                  fontWeight:
                                                      index == _selectedHour
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: index == _selectedHour
                                                      ? const Color(0xFF1E40AF)
                                                      : Colors.grey.shade500,
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: 24,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 180,
                            color: Colors.grey.shade200,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  AppLocalizations.of(context)!.minute,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Expanded(
                                  child: ListWheelScrollView.useDelegate(
                                    controller: _minuteController,
                                    itemExtent: 42,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        _selectedMinute = index;
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            return Center(
                                              child: Text(
                                                index.toString().padLeft(
                                                  2,
                                                  '0',
                                                ),
                                                style: TextStyle(
                                                  fontSize:
                                                      index == _selectedMinute
                                                      ? 24
                                                      : 18,
                                                  fontWeight:
                                                      index == _selectedMinute
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color:
                                                      index == _selectedMinute
                                                      ? const Color(0xFF1E40AF)
                                                      : Colors.grey.shade500,
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: 60,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Back button
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Continue button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ValidationButton(
                  label: 'Continue',
                  onPressed: _handleContinue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }
}
