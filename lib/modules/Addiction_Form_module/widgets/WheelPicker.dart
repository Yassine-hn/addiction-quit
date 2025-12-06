// New WheelDatePicker.dart - Custom wheel picker component
import 'package:flutter/material.dart';

class WheelDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final DateTime? minDate;
  final DateTime? maxDate;

  const WheelDatePicker({
    super.key,
    this.initialDate,
    required this.onDateChanged,
    this.minDate,
    this.maxDate,
  });

  @override
  State<WheelDatePicker> createState() => _WheelDatePickerState();
}

class _WheelDatePickerState extends State<WheelDatePicker> {
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _yearController;

  late List<String> _months;
  late List<int> _days;
  late List<int> _years;

  late int _selectedMonth;
  late int _selectedDay;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();

    // Initialize lists
    _months = _getMonthNames();
    _years = _generateYears();

    // Set initial values
    final initialDate = widget.initialDate ?? DateTime.now();
    _selectedMonth = initialDate.month - 1; // Zero-indexed for list
    _selectedDay = initialDate.day - 1; // Zero-indexed for list
    _selectedYear = _years.indexOf(initialDate.year);

    // Create controllers
    _monthController = FixedExtentScrollController(initialItem: _selectedMonth);
    _dayController = FixedExtentScrollController(initialItem: _selectedDay);
    _yearController = FixedExtentScrollController(initialItem: _selectedYear);

    // Generate initial days list
    _days = _generateDays(_selectedMonth + 1, _years[_selectedYear]);
  }

  List<String> _getMonthNames() {
    return [
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
  }

  List<int> _generateYears() {
    final currentYear = DateTime.now().year;
    final startYear = widget.minDate?.year ?? currentYear - 100;
    final endYear = widget.maxDate?.year ?? currentYear;

    return List.generate(
      endYear - startYear + 1,
      (index) => startYear + index,
    ).reversed.toList(); // Show most recent years first
  }

  List<int> _generateDays(int month, int year) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  void _updateSelectedDate() {
    final month = _monthController.selectedItem + 1;
    final day = _dayController.selectedItem + 1;
    final year = _years[_yearController.selectedItem];

    setState(() {
      _selectedMonth = _monthController.selectedItem;
      _selectedDay = _dayController.selectedItem;
      _selectedYear = _yearController.selectedItem;
    });

    widget.onDateChanged(DateTime(year, month, day));
  }

  void _onMonthChanged(int index) {
    final year = _years[_yearController.selectedItem];
    final month = index + 1;

    // Regenerate days list for the new month
    final newDays = _generateDays(month, year);

    // If current day selection is invalid for new month, adjust it
    if (_dayController.selectedItem >= newDays.length) {
      _dayController.jumpToItem(newDays.length - 1);
    }

    setState(() {
      _days = newDays;
    });

    _updateSelectedDate();
  }

  void _onDayChanged(int index) {
    setState(() {
      _selectedDay = index;
    });
    _updateSelectedDate();
  }

  void _onYearChanged(int index) {
    final year = _years[index];
    final month = _monthController.selectedItem + 1;

    // Regenerate days list for February in leap years
    if (month == 2) {
      final newDays = _generateDays(month, year);

      if (_dayController.selectedItem >= newDays.length) {
        _dayController.jumpToItem(newDays.length - 1);
      }

      setState(() {
        _days = newDays;
      });
    }

    setState(() {
      _selectedYear = index;
    });
    _updateSelectedDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
      ),
      child: Row(
        children: [
          // Month Picker
          Expanded(
            child: _buildWheelScrollView(
              controller: _monthController,
              items: _months,
              onChanged: _onMonthChanged,
              selectedIndex: _selectedMonth,
              label: 'Month',
            ),
          ),

          // Day Picker
          Expanded(
            child: _buildWheelScrollView(
              controller: _dayController,
              items: _days.map((d) => d.toString()).toList(),
              onChanged: _onDayChanged,
              selectedIndex: _selectedDay,
              label: 'Day',
            ),
          ),

          // Year Picker
          Expanded(
            child: _buildWheelScrollView(
              controller: _yearController,
              items: _years.map((y) => y.toString()).toList(),
              onChanged: _onYearChanged,
              selectedIndex: _selectedYear,
              label: 'Year',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheelScrollView({
    required FixedExtentScrollController controller,
    required List<String> items,
    required ValueChanged<int> onChanged,
    required int selectedIndex,
    required String label,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 0, 9, 180),
            ),
          ),
        ),
        Expanded(
          child: ListWheelScrollView(
            controller: controller,
            itemExtent: 50,
            diameterRatio: 1.5,
            perspective: 0.01,
            onSelectedItemChanged: onChanged,
            physics: const FixedExtentScrollPhysics(),
            children: List.generate(items.length, (index) {
              final isSelected = index == selectedIndex;
              return Center(
                child: Text(
                  items[index],
                  style: TextStyle(
                    fontSize: isSelected ? 22 : 18,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.grey[600],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}

// TimeWheelPicker.dart - Complete time picker with hours and minutes
class TimeWheelPicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimeWheelPicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  State<TimeWheelPicker> createState() => _TimeWheelPickerState();
}

class _TimeWheelPickerState extends State<TimeWheelPicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();

    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinute,
    );

    // Notify initial value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyTimeChanged();
    });
  }

  void _notifyTimeChanged() {
    widget.onTimeChanged(
      TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
    );
  }

  void _onHourChanged(int index) {
    setState(() {
      _selectedHour = index;
    });
    _notifyTimeChanged();
  }

  void _onMinuteChanged(int index) {
    setState(() {
      _selectedMinute = index;
    });
    _notifyTimeChanged();
  }

  String _formatTime() {
    final time = TimeOfDay(hour: _selectedHour, minute: _selectedMinute);
    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Large time display
        Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              Text(
                _formatTime(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 9, 180),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedHour < 12 ? 'Morning' : 'Afternoon',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Wheel pickers container
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Hours (0-23)
              Expanded(
                child: _buildWheelColumn(
                  controller: _hourController,
                  label: 'HOURS',
                  itemCount: 24,
                  formatter: (index) => index.toString().padLeft(2, '0'),
                  onChanged: _onHourChanged,
                  selectedIndex: _selectedHour,
                ),
              ),

              const VerticalDivider(
                color: Color(0xFFEEEEEE),
                width: 1,
                thickness: 1,
              ),

              // Minutes (0-59)
              Expanded(
                child: _buildWheelColumn(
                  controller: _minuteController,
                  label: 'MINUTES',
                  itemCount: 60,
                  formatter: (index) => index.toString().padLeft(2, '0'),
                  onChanged: _onMinuteChanged,
                  selectedIndex: _selectedMinute,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWheelColumn({
    required FixedExtentScrollController controller,
    required String label,
    required int itemCount,
    required String Function(int) formatter,
    required ValueChanged<int> onChanged,
    required int selectedIndex,
  }) {
    return Column(
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
        ),

        // Wheel
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                onChanged(controller.selectedItem);
              }
              return true;
            },
            child: ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: 40,
              diameterRatio: 1000,
              squeeze: 1.0,
              useMagnifier: true,
              magnification: 1.1,
              overAndUnderCenterOpacity: 0.4,
              physics: const FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: itemCount,
                builder: (context, index) {
                  final isSelected = index == selectedIndex;
                  return Center(
                    child: Text(
                      formatter(index),
                      style: TextStyle(
                        fontSize: isSelected ? 22 : 18,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? const Color.fromARGB(255, 0, 9, 180)
                            : Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }
}
