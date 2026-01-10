// file: app_routes.dart (updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home_screen.dart';
import './screens/profile_screen.dart';
import 'screens/dashboard_screen.dart';
import '../modules/community_module/screens/community_screen.dart';
import './screens/loading_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import '../modules/Addiction_Form_module/screens/Step0Welcome.dart';
import '../modules/Addiction_Form_module/data/user_data_service.dart';
import 'package:addiction_quit/modules/Addiction_Form_module/data/Cubit/UserInfoCubit.dart';

class AppRoutes {
  // Route names as constants
  static const String initial = '/';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String community = '/community';
  static const String loading = '/loading';
  static const String welcome = '/welcome';
  static const String formStart = '/formStart';
  static const String login = '/login';
  static const String signup = '/signup';

  // Helper to check if user exists
  static Future<bool> checkUserExists() async {
    return await UserDataService.userExists();
  }

  // Route generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<bool>(
            future: checkUserExists(),
            builder: (context, snapshot) {
              // Show loading while checking
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // If user exists, go to loading screen (then to home)
              // If not, go to welcome screen (onboarding)
              if (snapshot.hasData && snapshot.data == true) {
                return const LoadingScreen();
              } else {
                return BlocProvider(
                  create: (BuildContext context) => UserInfoCubit(),
                  child: const WelcomeScreen(),
                );
              }
            },
          ),
        );

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => UserProfileScreen());

      case community:
        return MaterialPageRoute(builder: (_) => const CommunityScreen());

      case loading:
        return MaterialPageRoute(builder: (_) => const LoadingScreen());

      case welcome:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => UserInfoCubit(),
            child: const WelcomeScreen(),
          ),
        );

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      // Add more routes here as needed

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
