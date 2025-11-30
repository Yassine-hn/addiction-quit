// File: lib/app_routes.dart

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import './screens/user_profile_screen.dart';
import 'screens/dashboard_screen.dart';
import '../data/repositories/progress_repository_impl.dart';
import './screens/community_screen.dart';
import './screens/loading_screen.dart';

class AppRoutes {
  // Route names as constants
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String community = '/community';
  static const String loadingScreen = '/loading';

  // Route generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => DashboardScreen(repository: ProgressRepositoryImpl()),
        );

      case profile:
        return MaterialPageRoute(builder: (_) => UserProfileScreen());

      case community:
        return MaterialPageRoute(builder: (_) => CommunityScreenFromModule());
      case loadingScreen:
        return MaterialPageRoute(builder: (_) => const LoadingScreen());

      // Add more routes here as needed
      // case profile:
      //   return MaterialPageRoute(builder: (_) => const ProfileScreen());

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
