import 'package:flutter/material.dart';
import 'presentation/app_routes.dart';

Future<bool> init_app() async {
  return true;
}

void main() async {
  await init_app();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.loadingScreen,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      //home: HomeScreen(),
    );
  }
}
