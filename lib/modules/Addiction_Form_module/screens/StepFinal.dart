// StepFinal.dart - Enhanced version with animations
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../data/Cubit/UserInfoCubit.dart';
import '../widgets/ValidationButton.dart';
import '../data/user_data_service.dart';
import 'data_saving_screen.dart';
import '../models/User_Info_model.dart';
import '../../../presentation/app_routes.dart';

class StepFinal extends StatefulWidget {
  const StepFinal({super.key});

  @override
  State<StepFinal> createState() => _StepFinalState();
}

class _StepFinalState extends State<StepFinal>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();

  bool _isUsernameValid = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Load existing username from cubit
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final currentUsername = cubit.state.username;

    if (currentUsername != null && currentUsername.isNotEmpty) {
      _usernameController.text = currentUsername;
      _validateUsername(currentUsername);
    }

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      _usernameFocusNode.requestFocus();
    });
  }

  void _validateUsername(String value) {
    setState(() {
      _isUsernameValid = value.trim().isNotEmpty && value.trim().length >= 2;
    });
  }

  // In your form screen file

  void _handleGetStarted() async {
    if (_isUsernameValid) {
      final username = _usernameController.text.trim();
      final cubit = context.read<UserInfoCubit>();

      // Update username in cubit
      cubit.updateUsername(username);
      cubit.debugPrint();

      // Create a future that handles all data saving operations
      final savingFuture = _saveUserData(cubit.state, username);

      // Navigate to transition screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DataSavingScreen(
            savingFuture: savingFuture,
            onComplete: () {
              // Clear navigation stack and navigate to home screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
            onError: () {
              // Navigate back to form with error message
              Navigator.pop(context);
              _showErrorDialog(context);
            },
          ),
        ),
      );
    }
  }

  Future<void> _saveUserData(UserInfoModel userInfo, String username) async {
    try {
      // 1. Get or create user ID and save to SharedPreferences
      final userId = await UserDataService.getOrCreateUserId(username);

      // 2. Create addiction instance in database
      await UserDataService.createAddiction(userId, userInfo);

      // Optional: Add a small delay to show the success animation
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      print('Error saving user data: $e');
      rethrow; // Re-throw to be caught by FutureBuilder
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Failed'),
        content: const Text(
          'There was an error saving your data. Please try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background Image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Get_Started_Screen.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Gradient overlay for better text visibility
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(isLandscape ? 0.7 : 0.6),
                      Colors.black.withOpacity(isLandscape ? 0.5 : 0.3),
                      Colors.black.withOpacity(isLandscape ? 0.7 : 0.6),
                    ],
                  ),
                ),
              ),

              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isLandscape ? 48.0 : 24.0,
                                vertical: isLandscape ? 16.0 : 0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Top spacer - dynamic based on orientation
                                  if (!isLandscape) const Spacer(flex: 1),

                                  // Title Section
                                  Flexible(
                                    flex: isLandscape ? 2 : 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Welcome to your\nnew life',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isLandscape ? 32 : 40,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            height: 1.2,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(height: isLandscape ? 12 : 20),

                                        // Divider line
                                        Container(
                                          width: isLandscape ? 60 : 80,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: isLandscape ? 16 : 24),

                                        Text(
                                          'How should we call you?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isLandscape ? 20 : 22,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Middle spacer
                                  SizedBox(height: isLandscape ? 20 : 40),

                                  // Input Section
                                  Flexible(
                                    flex: isLandscape ? 2 : 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Username Input
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: TextField(
                                            controller: _usernameController,
                                            focusNode: _usernameFocusNode,
                                            style: TextStyle(
                                              fontSize: isLandscape ? 18 : 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Enter your name',
                                              hintStyle: TextStyle(
                                                fontSize: isLandscape ? 16 : 18,
                                                color: Colors.white.withOpacity(
                                                  0.6,
                                                ),
                                              ),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: isLandscape
                                                        ? 16
                                                        : 20,
                                                  ),
                                              prefixIcon: Icon(
                                                Icons.person_outline,
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                                size: isLandscape ? 24 : 28,
                                              ),
                                              suffixIcon:
                                                  _usernameController
                                                      .text
                                                      .isNotEmpty
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _usernameController
                                                              .clear();
                                                          _isUsernameValid =
                                                              false;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.clear,
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        size: isLandscape
                                                            ? 20
                                                            : 24,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            onChanged: _validateUsername,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            cursorColor: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: isLandscape ? 12 : 16),

                                        // Validation message
                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child:
                                              _usernameController
                                                  .text
                                                  .isNotEmpty
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      _isUsernameValid
                                                          ? Icons.check_circle
                                                          : Icons.error_outline,
                                                      color: _isUsernameValid
                                                          ? Colors.green[300]
                                                          : Colors.orange[300],
                                                      size: isLandscape
                                                          ? 16
                                                          : 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      _isUsernameValid
                                                          ? 'Perfect! Ready to begin'
                                                          : 'Enter at least 2 characters',
                                                      style: TextStyle(
                                                        fontSize: isLandscape
                                                            ? 12
                                                            : 14,
                                                        color: _isUsernameValid
                                                            ? Colors.green[300]
                                                            : Colors
                                                                  .orange[300],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                        ),

                                        // Welcome message
                                        if (isLandscape)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 16,
                                            ),
                                            child: AnimatedOpacity(
                                              opacity:
                                                  _usernameController
                                                      .text
                                                      .isNotEmpty
                                                  ? 1.0
                                                  : 0.0,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: Text(
                                                _usernameController
                                                        .text
                                                        .isNotEmpty
                                                    ? 'Ready to begin your journey, ${_usernameController.text}?'
                                                    : '',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Bottom spacer and button
                                  Flexible(
                                    flex: isLandscape ? 2 : 3,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (!isLandscape) const Spacer(),

                                        // Welcome message (for portrait only)
                                        if (!isLandscape)
                                          AnimatedOpacity(
                                            opacity:
                                                _usernameController
                                                    .text
                                                    .isNotEmpty
                                                ? 1.0
                                                : 0.5,
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 20,
                                              ),
                                              child: Text(
                                                _usernameController
                                                        .text
                                                        .isNotEmpty
                                                    ? 'Ready to begin your journey, ${_usernameController.text}?'
                                                    : 'Complete your profile to start',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),

                                        // Get Started Button
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                  255,
                                                  0,
                                                  9,
                                                  180,
                                                ).withOpacity(0.4),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: ValidationButton(
                                            label: 'GET STARTED',
                                            onPressed: () => _isUsernameValid
                                                ? _handleGetStarted()
                                                : null,
                                            enabled: _isUsernameValid,
                                            backgroundColor: Colors.white,
                                            textColor: const Color.fromARGB(
                                              255,
                                              0,
                                              9,
                                              180,
                                            ),
                                            height: isLandscape ? 50 : 60,
                                            borderRadius: 16,
                                          ),
                                        ),

                                        // Bottom spacing
                                        SizedBox(
                                          height: isLandscape
                                              ? MediaQuery.of(
                                                      context,
                                                    ).padding.bottom +
                                                    20
                                              : MediaQuery.of(
                                                      context,
                                                    ).padding.bottom +
                                                    40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
