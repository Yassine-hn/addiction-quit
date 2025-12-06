import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class MilestoneSelector extends StatelessWidget {
  final Function(int days) onMilestoneSelected;

  const MilestoneSelector({super.key, required this.onMilestoneSelected});

  List<Map<String, dynamic>> _getPredefinedMilestones(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {'days': 1, 'label': l10n.oneDayMilestone, 'icon': Icons.calendar_today},
      {'days': 7, 'label': l10n.oneWeekMilestone, 'icon': Icons.date_range},
      {'days': 14, 'label': l10n.twoWeeksMilestone, 'icon': Icons.event},
      {
        'days': 30,
        'label': l10n.oneMonthMilestone,
        'icon': Icons.calendar_month,
      },
      {'days': 60, 'label': l10n.twoMonthsMilestone, 'icon': Icons.event_note},
      {
        'days': 90,
        'label': l10n.threeMonthsMilestone,
        'icon': Icons.calendar_view_month,
      },
      {
        'days': 180,
        'label': l10n.sixMonthsMilestone,
        'icon': Icons.calendar_view_week,
      },
      {
        'days': 365,
        'label': l10n.oneYearMilestone,
        'icon': Icons.calendar_today_outlined,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final milestones = _getPredefinedMilestones(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectMilestone,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: milestones.length,
                itemBuilder: (context, index) {
                  final milestone = milestones[index];
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
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
