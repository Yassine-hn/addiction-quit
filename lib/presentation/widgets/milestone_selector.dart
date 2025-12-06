import 'package:flutter/material.dart';

class MilestoneSelector extends StatelessWidget {
  final Function(int days) onMilestoneSelected;

  const MilestoneSelector({
    super.key,
    required this.onMilestoneSelected,
  });

  static const List<Map<String, dynamic>> predefinedMilestones = [
    {'days': 1, 'label': '1 Day', 'icon': Icons.calendar_today},
    {'days': 7, 'label': '1 Week', 'icon': Icons.date_range},
    {'days': 14, 'label': '2 Weeks', 'icon': Icons.event},
    {'days': 30, 'label': '1 Month', 'icon': Icons.calendar_month},
    {'days': 60, 'label': '2 Months', 'icon': Icons.event_note},
    {'days': 90, 'label': '3 Months', 'icon': Icons.calendar_view_month},
    {'days': 180, 'label': '6 Months', 'icon': Icons.calendar_view_week},
    {'days': 365, 'label': '1 Year', 'icon': Icons.calendar_today_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Milestone',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: predefinedMilestones.length,
                itemBuilder: (context, index) {
                  final milestone = predefinedMilestones[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        milestone['icon'] as IconData,
                        color: const Color(0xFF4361EE),
                      ),
                      title: Text(milestone['label'] as String),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pop(context);
                        onMilestoneSelected(milestone['days'] as int);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

