// file: main.dart (updated)
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'presentation/app_routes.dart';
import 'modules/Addiction_Form_module/data/user_data_service.dart';
import 'data/databases/db_helper.dart';
import 'package:firebase_core/firebase_core.dart';

Future<bool> init_app() async {
  try {
    // Initialize SharedPreferences
    await SharedPreferences.getInstance();

    // Initialize database
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database;

    // Check if user already exists
    final userExists = await UserDataService.userExists();

    if (userExists) {
      final user = await UserDataService.getCurrentUser();
      print(
        'App initialized. Existing user found: ${user?['name']} (ID: ${user?['id']})',
      );
    } else {
      print(
        'App initialized. No existing user found. User needs to go through onboarding.',
      );
    }

    return true;
  } catch (e) {
    print('Failed to initialize app: $e');
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init_app();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Addiction Quit App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      //locale: Locale('ar', ''),
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
