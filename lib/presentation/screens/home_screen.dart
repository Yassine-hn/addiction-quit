import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/useful_widgets.dart';
import '../../logic/services/home_backend_functions.dart';
import '../../logic/cubits/daily_checkin_cubit.dart';
import '../../logic/cubits/language_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
  with SingleTickerProviderStateMixin { // SingleTickerProviderStateMixin Provides a Ticker (vsync) for AnimationController used in this screen's animations.

  final TextEditingController _journalController = TextEditingController();
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;
  late Future<Map<String, String>> _sobrietyFuture; // Holds async result for user's sobriety time (days, hours, minutes, slips)
  late Future<Map<String, dynamic>> _savingsFuture; // Holds async result for user's savings stats (money saved, streak, time saved)
  bool _isResetting = false;
  late DailyCheckInCubit _checkInCubit;

  @override
  void initState() {
    super.initState();
    _checkInCubit = DailyCheckInCubit();
    _sobrietyFuture = getSobrietyTime();
    _savingsFuture = getSavingsStats();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _journalController.dispose();
    _animationController?.dispose();
    _checkInCubit.close();
    super.dispose();
  }

  void _reloadStats() {
    setState(() {
      _sobrietyFuture = getSobrietyTime();
      _savingsFuture = getSavingsStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _checkInCubit,
      child: Scaffold(
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
                      _buildSobrietyCounter(context),
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
        bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _showMenu(context),
                  child: Icon(Icons.menu, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: FutureBuilder<String>(
                    future: getGreetingMessage(),
                    builder: (context, snapshot) {
                      final l10n = AppLocalizations.of(context)!;
                      final greetingData = snapshot.data ?? 'goodMorning|User';
                      final parts = greetingData.split('|');
                      final greetingKey = parts[0];
                      final userName = parts.length > 1 ? parts[1] : 'User';

                      String greeting;
                      switch (greetingKey) {
                        case 'goodMorning':
                          greeting = '${l10n.goodMorning}, $userName';
                          break;
                        case 'goodAfternoon':
                          greeting = '${l10n.goodAfternoon}, $userName';
                          break;
                        case 'goodEvening':
                          greeting = '${l10n.goodEvening}, $userName';
                          break;
                        default:
                          greeting = l10n.helloUser;
                      }

                      return Text(
                        greeting,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildLanguageToggle(context),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE8F4F8),
            child: Icon(Icons.person, color: Color(0xFF00A3E0), size: 20),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.login, color: Color(0xFF00A3E0)),
                title: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to sign in screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sign In screen coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add, color: Color(0xFF00A3E0)),
                title: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to sign up screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sign Up screen coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageToggle(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final isArabic = state.locale.languageCode == 'ar';
        return GestureDetector(
          onTap: () => context.read<LanguageCubit>().toggleLanguage(),
          child: Container(
            width: 40,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                isArabic ? 'ع' : 'EN',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00A3E0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSobrietyCounter(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/see-background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.0),
            Colors.black.withOpacity(0.0),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: FutureBuilder<Map<String, String>>(
        future: _sobrietyFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final sobrietyTime = snapshot.data ?? getDefaultSobrietyTime();
          final slips = sobrietyTime['slips'] ?? '0';

          if (isLoading && !_isResetting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.youAreSoberFor,
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
                        _buildTimeUnit(
                          context,
                          sobrietyTime['days'] ?? '42',
                          AppLocalizations.of(context)!.days,
                        ),
                        const SizedBox(height: 8),
                        _buildTimeUnit(
                          context,
                          sobrietyTime['hours'] ?? '11',
                          AppLocalizations.of(context)!.hours,
                        ),
                        const SizedBox(height: 8),
                        _buildTimeUnit(
                          context,
                          sobrietyTime['minutes'] ?? '23',
                          AppLocalizations.of(context)!.minutes,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Slips',
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        slips,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: _isResetting
                              ? null
                              : () async {
                                  setState(() {
                                    _isResetting = true;
                                  });
                                  final success = await resetSobrietyCounter();
                                  if (success) {
                                    _reloadStats();
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Counter reset successfully'),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Failed to reset counter'),
                                          backgroundColor: Colors.red[600],
                                        ),
                                      );
                                    }
                                  }
                                  if (mounted) {
                                    setState(() {
                                      _isResetting = false;
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.12),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: _isResetting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTimeUnit(BuildContext context, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[200],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _savingsFuture,
      builder: (context, snapshot) {
        final stats = snapshot.data ?? getDefaultSavingsStats();
        final moneySaved = stats['moneySaved'] as String?;

        return LayoutBuilder(
          builder: (context, constraints) {
            final showMoneyCard = moneySaved != null;

            return Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: AppLocalizations.of(context)!.streak,
                    value: stats['streak'].toString(),
                    unit: AppLocalizations.of(context)!.daysUnit,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: AppLocalizations.of(context)!.timeSaved,
                    value: stats['timeSaved'] ?? '0 min',
                    unit: '',
                  ),
                ),
                if (showMoneyCard) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: AppLocalizations.of(context)!.moneySaved,
                      value: moneySaved,
                      unit: '',
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCheckInCard() {
    return BlocConsumer<DailyCheckInCubit, DailyCheckInState>(
      listener: (context, state) {
        if (state is CheckInCompleted) {
          _animationController?.forward();
          _reloadStats();
        } else if (state is CheckInError) {
          final l10n = AppLocalizations.of(context)!;
          String errorMessage;
          if (state.message == 'VALIDATION_ERROR') {
            errorMessage = l10n.pleaseSelectMoodAndCraving;
          } else if (state.message.contains('Failed')) {
            errorMessage = l10n.failedToSubmitCheckIn;
          } else {
            errorMessage = state.message;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red[600],
            ),
          );
        }
      },
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: state is CheckInCompleted
              ? _buildCompletedCheckIn()
              : _buildCheckInForm(state),
        );
      },
    );
  }

  Widget _buildCompletedCheckIn() {
    if (_scaleAnimation == null || _fadeAnimation == null) {
      return const SizedBox();
    }

    return Container(
      key: const ValueKey('completed'),
      padding: const EdgeInsets.all(40),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnimation!,
            child: FadeTransition(
              opacity: _fadeAnimation!,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[50],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 70,
                  color: Colors.green[600],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _fadeAnimation!,
            child: Text(
              AppLocalizations.of(context)!.checkInCompleted,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _fadeAnimation!,
            child: Text(
              AppLocalizations.of(context)!.greatJobStayingOnTrack,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          FadeTransition(
            opacity: _fadeAnimation!,
            child: TextButton.icon(
              onPressed: () {
                _checkInCubit.resetCheckIn();
                _journalController.clear();
                _animationController?.reset();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.checkInAgain),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00A3E0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInForm(DailyCheckInState state) {
    final isSubmitting = state is CheckInSubmitting;
    final currentState = state is CheckInInProgress ? state : null;

    return Container(
      key: const ValueKey('form'),
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
            AppLocalizations.of(context)!.yourDailyCheckIn,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          _buildMoodSection(currentState?.selectedMood ?? ''),
          const SizedBox(height: 24),
          _buildCravingSection(currentState?.cravingLevel ?? 0.5),
          const SizedBox(height: 24),
          _buildSlipSection(
            currentState?.slipped ?? false,
            currentState?.slipAmount ?? 0,
          ),
          const SizedBox(height: 24),
          _buildJournalSection(),
          const SizedBox(height: 24),
          _buildCheckInButton(isSubmitting),
        ],
      ),
    );
  }

  Widget _buildMoodSection(String selectedMood) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.myMood,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: _buildMoodButton(
                    context,
                    '😖',
                    AppLocalizations.of(context)!.awful,
                    selectedMood,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: _buildMoodButton(
                    context,
                    '😔',
                    AppLocalizations.of(context)!.sad,
                    selectedMood,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: _buildMoodButton(
                    context,
                    '😐',
                    AppLocalizations.of(context)!.okay,
                    selectedMood,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: _buildMoodButton(
                    context,
                    '😊',
                    AppLocalizations.of(context)!.good,
                    selectedMood,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMoodButton(
    BuildContext context,
    String emoji,
    String label,
    String selectedMood,
  ) {
    final isSelected = selectedMood == label;

    return GestureDetector(
      onTap: () {
        _checkInCubit.updateMood(label);
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
          mainAxisSize: MainAxisSize.min,
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

  Widget _buildCravingSection(double cravingLevel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.cravingLevel,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.low,
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
                    _checkInCubit.updateCravingLevel(value);
                  },
                ),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.high,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlipSection(bool slipped, int slipAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Did you slip today?',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ChoiceChip(
              label: const Text('No'),
              selected: !slipped,
              onSelected: (selected) {
                if (selected) {
                  _checkInCubit.updateSlipped(false);
                }
              },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Yes'),
              selected: slipped,
              onSelected: (selected) {
                if (selected) {
                  _checkInCubit.updateSlipped(true);
                }
              },
            ),
          ],
        ),
        if (slipped) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'How many times?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: slipAmount.clamp(1, 10).toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: slipAmount.toString(),
                  onChanged: (value) {
                    _checkInCubit.updateSlipAmount(value.round());
                  },
                ),
              ),
              Container(
                width: 48,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  slipAmount.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildJournalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.todayJournalOptional,
          style: const TextStyle(
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
            controller: _journalController,
            maxLines: 4,
            onChanged: (value) {
              _checkInCubit.updateJournalEntry(value);
            },
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.writeAboutYourDay,
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

  Widget _buildCheckInButton(bool isSubmitting) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isSubmitting
            ? null
            : () {
                _checkInCubit.submitCheckIn(
                  submitDailyCheckIn,
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A3E0),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                AppLocalizations.of(context)!.completeCheckIn,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildQuoteCard() {
    return FutureBuilder<Map<String, String>>(
      future: getDailyQuote(),
      builder: (context, snapshot) {
        final quote = snapshot.data ?? getDefaultQuote();

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
                AppLocalizations.of(context)!.dailyQuote,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '"${quote['text']}"',
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '— ${quote['author']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
