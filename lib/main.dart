// file: main.dart (updated)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'presentation/app_routes.dart';
import 'modules/Addiction_Form_module/data/user_data_service.dart';
import 'data/databases/db_helper.dart';
import 'data/utils/database_seeder.dart'; // For seeding - can remove after first run
import 'logic/cubits/language_cubit.dart';
import 'logic/cubits/auth_cubit.dart';
import 'data/repositories/auth_repository.dart';
import 'api/api_service.dart';
import 'package:firebase_core/firebase_core.dart';

Future<bool> init_app() async {
  try {
    // Initialize SharedPreferences
    await SharedPreferences.getInstance();

    // Initialize API service
    ApiService().initialize();

    // Initialize database
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database;

    // ============================================================================
    // 🌱 DATABASE SEEDING - REMOVE THIS SECTION AFTER FIRST RUN
    // ============================================================================
    // Uncomment the lines below to seed the local database with test data.
    // After running the app once successfully, DELETE or COMMENT OUT this entire
    // section (lines marked with "REMOVE AFTER FIRST RUN") to prevent re-seeding
    // on every app launch.
    
     final seeder = DatabaseSeeder();                    // REMOVE AFTER FIRST RUN
     await seeder.seed();                                // REMOVE AFTER FIRST RUN
     print('✅ Local database seeded successfully!');    // REMOVE AFTER FIRST RUN
    
    // ============================================================================
    // END OF SEEDING SECTION
    // ============================================================================

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
  
  // Initialize services and repositories
  final apiService = ApiService();
  final authRepository = AuthRepositoryImpl(apiService);
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(
          create: (context) => AuthCubit(authRepository)..checkAuthStatus(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
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
          locale: langState.locale,
          supportedLocales: LanguageCubit.getSupportedLocales(),
          // Always send users through the normal app flow. If they already have
          // a persisted (implicit) account, AppRoutes will take them to the
          // loading/home flow; otherwise they land on onboarding without needing
          // an explicit login.
          initialRoute: AppRoutes.initial,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
