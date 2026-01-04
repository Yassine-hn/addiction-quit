import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/useful_widgets.dart';
import '../../logic/services/home_backend_functions.dart';
import '../../logic/cubits/daily_chekcin_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailyCheckInCubit(),
      child: const DailyCheckInScreen(),
    );
  }
}

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({super.key});

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController journalController = TextEditingController();
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
    journalController.dispose();
    _animationController?.dispose();
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
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
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
                Icon(Icons.menu, color: Colors.grey[600]),
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
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            FutureBuilder<Map<String, String>>(
              future: getSobrietyTime(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.white);
                }

                final sobrietyTime = snapshot.data ?? getDefaultSobrietyTime();

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: _buildTimeUnit(
                            context,
                            sobrietyTime['days'] ?? '42',
                            AppLocalizations.of(context)!.days,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: _buildTimeUnit(
                            context,
                            sobrietyTime['hours'] ?? '11',
                            AppLocalizations.of(context)!.hours,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: _buildTimeUnit(
                            context,
                            sobrietyTime['minutes'] ?? '23',
                            AppLocalizations.of(context)!.minutes,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(BuildContext context, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[200],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return FutureBuilder<Map<String, dynamic>>(
      future: getSavingsStats(),
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
                context.read<DailyCheckInCubit>().resetCheckIn();
                journalController.clear();
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
        context.read<DailyCheckInCubit>().updateMood(label);
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
                    context.read<DailyCheckInCubit>().updateCravingLevel(value);
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
            controller: journalController,
            maxLines: 4,
            onChanged: (value) {
              context.read<DailyCheckInCubit>().updateJournalEntry(value);
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
                context.read<DailyCheckInCubit>().submitCheckIn(
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
