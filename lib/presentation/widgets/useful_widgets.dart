import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const CustomBottomNavBar({super.key, required this.activeIndex});

  void _onNavItemTapped(BuildContext context, int index) {
    if (index == activeIndex) return;

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/community');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                Icons.home,
                AppLocalizations.of(context)!.home,
                context,
                isActive: activeIndex == 0,
                index: 0,
              ),
              _buildNavItem(
                Icons.dashboard,
                AppLocalizations.of(context)!.dashboard,
                context,
                isActive: activeIndex == 1,
                index: 1,
              ),
              _buildNavItem(
                Icons.person,
                AppLocalizations.of(context)!.profile,
                context,
                isActive: activeIndex == 2,
                index: 2,
              ),
              _buildNavItem(
                Icons.people_outline,
                AppLocalizations.of(context)!.community,
                context,
                isActive: activeIndex == 3,
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    BuildContext context, {
    required bool isActive,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => _onNavItemTapped(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF00A3E0) : Colors.grey[400],
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? const Color(0xFF00A3E0) : Colors.grey[400],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 4,
                runSpacing: 4,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                  if (unit.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        unit,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class MoodSelector extends StatefulWidget {
  final Function(String) onMoodSelected;
  final String initialMood;

  const MoodSelector({
    super.key,
    required this.onMoodSelected,
    this.initialMood = '',
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  late String selectedMood;

  @override
  void initState() {
    super.initState();
    selectedMood = widget.initialMood;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Mood',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(child: _buildMoodButton('😖', 'Awful')),
            const SizedBox(width: 8),
            Flexible(child: _buildMoodButton('😔', 'Sad')),
            const SizedBox(width: 8),
            Flexible(child: _buildMoodButton('😐', 'Okay')),
            const SizedBox(width: 8),
            Flexible(child: _buildMoodButton('😊', 'Good')),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodButton(String emoji, String label) {
    final isSelected = selectedMood == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = label;
        });
        widget.onMoodSelected(label);
      },
      child: Container(
        constraints: const BoxConstraints(minWidth: 60, maxWidth: 80),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F4F8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00A3E0) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? const Color(0xFF00A3E0)
                      : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
