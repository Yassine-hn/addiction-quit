import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class MilestoneSelector extends StatelessWidget {
  final Function(int days, int points) onMilestoneSelected;

  const MilestoneSelector({super.key, required this.onMilestoneSelected});

  String _getMilestoneLabel(BuildContext context, int days) {
    final l10n = AppLocalizations.of(context)!;
    switch (days) {
      case 1:
        return l10n.milestone1Day;
      case 3:
        return l10n.milestone3Days;
      case 7:
        return l10n.milestone7Days;
      case 14:
        return l10n.milestone14Days;
      case 21:
        return l10n.milestone21Days;
      case 30:
        return l10n.milestone30Days;
      case 40:
        return l10n.milestone40Days;
      case 50:
        return l10n.milestone50Days;
      case 60:
        return l10n.milestone60Days;
      case 75:
        return l10n.milestone75Days;
      case 90:
        return l10n.milestone90Days;
      case 100:
        return l10n.milestone100Days;
      case 120:
        return l10n.milestone120Days;
      case 150:
        return l10n.milestone150Days;
      case 180:
        return l10n.milestone180Days;
      case 200:
        return l10n.milestone200Days;
      case 250:
        return l10n.milestone250Days;
      case 300:
        return l10n.milestone300Days;
      case 365:
        return l10n.milestone365Days;
      default:
        return l10n.daysMilestone(days);
    }
  }

  List<Map<String, dynamic>> _getPredefinedMilestones(BuildContext context) {
    return [
      // 🌱 Getting Started
      {'days': 1, 'label': _getMilestoneLabel(context, 1), 'icon': Icons.calendar_today, 'points': 10},
      {'days': 3, 'label': _getMilestoneLabel(context, 3), 'icon': Icons.trending_up, 'points': 25},
      {'days': 7, 'label': _getMilestoneLabel(context, 7), 'icon': Icons.date_range, 'points': 50},
      {'days': 14, 'label': _getMilestoneLabel(context, 14), 'icon': Icons.event, 'points': 100},
      {'days': 21, 'label': _getMilestoneLabel(context, 21), 'icon': Icons.build, 'points': 150},
      {'days': 30, 'label': _getMilestoneLabel(context, 30), 'icon': Icons.calendar_month, 'points': 200},

      // 🔥 Building Momentum
      {'days': 40, 'label': _getMilestoneLabel(context, 40), 'icon': Icons.trending_flat, 'points': 250},
      {'days': 50, 'label': _getMilestoneLabel(context, 50), 'icon': Icons.mood, 'points': 300},
      {'days': 60, 'label': _getMilestoneLabel(context, 60), 'icon': Icons.event_note, 'points': 350},
      {'days': 75, 'label': _getMilestoneLabel(context, 75), 'icon': Icons.emoji_events, 'points': 425},
      {'days': 90, 'label': _getMilestoneLabel(context, 90), 'icon': Icons.calendar_view_month, 'points': 500},
      {'days': 100, 'label': _getMilestoneLabel(context, 100), 'icon': Icons.star, 'points': 600},
      {'days': 120, 'label': _getMilestoneLabel(context, 120), 'icon': Icons.verified, 'points': 700},
      {'days': 150, 'label': _getMilestoneLabel(context, 150), 'icon': Icons.check_circle, 'points': 850},
      {'days': 180, 'label': _getMilestoneLabel(context, 180), 'icon': Icons.calendar_view_week, 'points': 1000},

      // 🏆 Major Milestones
      {'days': 200, 'label': _getMilestoneLabel(context, 200), 'icon': Icons.landscape, 'points': 1200},
      {'days': 250, 'label': _getMilestoneLabel(context, 250), 'icon': Icons.flag, 'points': 1500},
      {'days': 300, 'label': _getMilestoneLabel(context, 300), 'icon': Icons.emoji_events_outlined, 'points': 1800},
      {'days': 365, 'label': _getMilestoneLabel(context, 365), 'icon': Icons.calendar_today_outlined, 'points': 2000},
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
                      subtitle: Text('${milestone['points']} points'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        onMilestoneSelected(milestone['days'] as int, milestone['points'] as int);
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
