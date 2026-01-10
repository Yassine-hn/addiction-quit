// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/services/profile_backend_functions.dart';
import '../widgets/useful_widgets.dart';
import '../../modules/Addiction_Form_module/screens/Step0Welcome.dart';
import '../../modules/Addiction_Form_module/data/Cubit/UserInfoCubit.dart';
import '../../data/repositories/settings_repository.dart';
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';
import '../app_routes.dart';

import 'login_screen.dart';
import 'signup_screen.dart';
import '../../logic/cubits/auth_cubit.dart';
import '../../logic/cubits/auth_state.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 16),
                    _buildAuthCta(context),
                    const SizedBox(height: 24),
                    _buildNewAddictionButton(context),
                    const SizedBox(height: 24),
                    _buildAchievementsSection(),
                    const SizedBox(height: 24),
                    _buildJourneySection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(activeIndex: 2),
    );
  }

  Widget _buildAuthCta(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final loggedIn = state is AuthAuthenticated;

        if (loggedIn) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A3E0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      color: Color(0xFF00A3E0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          state.email,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF00C853),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00A3E0),
                    const Color(0xFF00A3E0).withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.lock_open,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.profile,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in or create an account to sync your progress.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24),
          Text(
            AppLocalizations.of(context)!.profile,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Open settings
            },
            child: Icon(Icons.settings_outlined, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return FutureBuilder<Map<String, String>>(
      future: getUserProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data ?? getDefaultUserProfile();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
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
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFE4D6),
                  border: Border.all(color: const Color(0xFF00A3E0), width: 3),
                ),
                child: const Center(
                  child: Icon(Icons.person, size: 50, color: Color(0xFFFF8C42)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                profile['name'] ?? 'Alex J.',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profile['tagline'] ?? 'Your journey to a better you',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementsSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getUserAchievements(),
      builder: (context, snapshot) {
        final achievements = snapshot.data ?? getDefaultAchievements();

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
              Text(
                AppLocalizations.of(context)!.previousAchievements,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...achievements.asMap().entries.map((entry) {
                final index = entry.key;
                final achievement = entry.value;
                return Column(
                  children: [
                    if (index > 0) const SizedBox(height: 12),
                    _buildAchievementItem(
                      icon: _getIconFromString(achievement['icon']),
                      title: achievement['title'],
                      date: achievement['date'] is Map
                          ? AppLocalizations.of(context)!.awardedOn(
                              '${(achievement['date'] as Map)['month']} ${(achievement['date'] as Map)['day']}, ${(achievement['date'] as Map)['year']}',
                            )
                          : achievement['date'] as String,
                      color: const Color(0xFF00A3E0),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementItem({
    required IconData icon,
    required String title,
    required String date,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneySection() {
    // Fetch journeys and the currently selected addiction ID
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        getUserJourneys(),
        SharedPreferencesHelper.getAddictionId(),
      ]),
      builder: (context, snapshot) {
        final journeys = (snapshot.hasData && snapshot.data![0] is List<Map<String, dynamic>>)
            ? snapshot.data![0] as List<Map<String, dynamic>>
            : getDefaultJourneys();
        final currentAddictionId = (snapshot.hasData) ? snapshot.data![1] as int? : null;

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
              Text(
                AppLocalizations.of(context)!.myJourney,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...journeys.asMap().entries.map((entry) {
                final index = entry.key;
                final journey = entry.value;
                return Column(
                  children: [
                    if (index > 0) const SizedBox(height: 12),
                    _buildJourneyItem(
                      icon: _getIconFromString(journey['icon']),
                      title: journey['title'],
                      subtitle: AppLocalizations.of(context)!.currentStreak(
                        int.tryParse(journey['subtitle'].toString()) ?? 0,
                      ),
                      days: AppLocalizations.of(context)!.daysDays(
                        int.tryParse(journey['days'].toString()) ?? 0,
                      ),
                      color: const Color(0xFF00A3E0),
                      addictionId: journey['addiction_id'] as int?,
                      isCurrent: (journey['addiction_id'] != null &&
                          currentAddictionId != null &&
                          (journey['addiction_id'] as int) == currentAddictionId),
                      context: context,
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJourneyItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String days,
    required Color color,
    int? addictionId,
    bool isCurrent = false,
    BuildContext? context,
  }) {
    return InkWell(
      onTap: addictionId != null && context != null
          ? () async {
              // Switch to this addiction
              final settingsRepo = SettingsRepository();
              await settingsRepo.saveCurrentAddictionId(addictionId);
              await SharedPreferencesHelper.saveAddictionId(addictionId);

              // Navigate to dashboard to see updated data
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent ? const Color(0xFF00C853).withOpacity(0.08) : color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent ? const Color(0xFF00C853).withOpacity(0.6) : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCurrent ? const Color(0xFF00C853).withOpacity(0.15) : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isCurrent ? const Color(0xFF00C853) : color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C853).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFF00C853).withOpacity(0.6)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.check_circle, size: 14, color: Color(0xFF00C853)),
                              SizedBox(width: 4),
                              Text(
                                'Current',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF00C853),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              days,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'coffee':
        return Icons.local_cafe_outlined;
      case 'phone':
        return Icons.phone_android_outlined;
      case 'smoke':
        return Icons.smoke_free_outlined;
      default:
        return Icons.star_outline;
    }
  }

  Widget _buildNewAddictionButton(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (BuildContext context) => UserInfoCubit(),
                child: const WelcomeScreen(),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4361EE),
                const Color(0xFF4361EE).withOpacity(0.8),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.newAddiction,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.startTrackingNewAddiction,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
