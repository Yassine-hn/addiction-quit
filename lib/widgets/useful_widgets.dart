import 'package:flutter/material.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int activeIndex;
  const CustomBottomNavBar({
    super.key, 
    required this.activeIndex,
    });
  // method _onNavItemTapped added so the bottom navbar  works for navigation between screens
  void _onNavItemTapped(BuildContext context, int index) {
    // Don't navigate if already on the current screen
    if (index == activeIndex) return;
    
    // Handle navigation to other screens
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/resources');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/community');
    }
  } // _onNavItemTapped

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
                'Home',
                context,
                isActive: activeIndex == 0,
                index: 0,
                ), // _buildNavItem
              _buildNavItem(
                Icons.bar_chart,
                'Progress',
                context,
                isActive: activeIndex == 1,
                index: 1, 
              ),// _buildNavItem
              _buildNavItem(
                Icons.bookmark_border,
                'Resources',
                context,
                isActive: activeIndex == 2,
                index: 2,
              ),// _buildNavItem
              _buildNavItem(
                Icons.people_outline,
                'Community',
                context,
                isActive: activeIndex == 3,
                index: 3,
                
              ),// _buildNavItem
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon, 
    String label, 
    BuildContext context,
    {required bool isActive,
    required int index,}
    ) {
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
  } // _buildNavItem
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    unit,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ),
              ],
            ],
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
            _buildMoodButton('😖', 'Awful'),
            _buildMoodButton('😔', 'Sad'),
            _buildMoodButton('😐', 'Okay'),
            _buildMoodButton('😊', 'Good'),
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
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
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
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? const Color(0xFF00A3E0) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
