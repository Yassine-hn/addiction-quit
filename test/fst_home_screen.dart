import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sobriety Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      home: const DailyCheckInScreen(),
    );
  }
}

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({super.key});

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  String selectedMood = '';
  double cravingLevel = 0.5;
  final TextEditingController journalController = TextEditingController();

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSobrietyCounter(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    _buildCheckInCard(),
                    const SizedBox(height: 16),
                    _buildQuoteCard(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.menu, color: Colors.grey[600]),
              const SizedBox(width: 12),
              const Text(
                'Good morning, Alex',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE8F4F8),
            child: Icon(Icons.person, color: Color(0xFF00A3E0), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSobrietyCounter() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/see-background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.5),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Text(
              'You are sober for',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[100],
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTimeUnit('42', 'DAYS'),
                const SizedBox(width: 8),
                _buildTimeUnit('11', 'HOURS'),
                const SizedBox(width: 8),
                _buildTimeUnit('23', 'SECONDS'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[200],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Streak', '42', 'days')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Money\nSaved', '\$210', '')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Milestone', '8', 'days')),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String unit) {
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

  Widget _buildCheckInCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Daily Check-in',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          _buildMoodSection(),
          const SizedBox(height: 24),
          _buildCravingSection(),
          const SizedBox(height: 24),
          _buildJournalSection(),
          const SizedBox(height: 24),
          _buildCheckInButton(),
        ],
      ),
    );
  }

  Widget _buildMoodSection() {
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
            _buildMoodButton('😊', 'Good', isSelected: true),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodButton(
    String emoji,
    String label, {
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = label;
        });
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

  Widget _buildCravingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Craving Level',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Low',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFF00A3E0),
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: const Color(0xFF00A3E0),
                  overlayColor: const Color(0xFF00A3E0).withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: cravingLevel,
                  onChanged: (value) {
                    setState(() {
                      cravingLevel = value;
                    });
                  },
                ),
              ),
            ),
            Text(
              'High',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJournalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Journal (Optional)",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: journalController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write about your day...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          // Action de check-in
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check-in completed!'),
              backgroundColor: Color(0xFF00A3E0),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A3E0),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Complete Check-in',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Quote',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '"The greatest glory in living lies not in never falling, but in rising every time we fall."',
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '— Nelson Mandela',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
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
              _buildNavItem(Icons.home, 'Home', isActive: true),
              _buildNavItem(Icons.bar_chart, 'Progress', isActive: false),
              _buildNavItem(
                Icons.bookmark_border,
                'Resources',
                isActive: false,
              ),
              _buildNavItem(Icons.people_outline, 'Community', isActive: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {required bool isActive}) {
    return Column(
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
    );
  }
}
