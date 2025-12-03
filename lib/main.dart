import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/Addiction_Form_module/data/Cubit/UserInfoCubit.dart';
import 'presentation/app_routes.dart';
import 'modules/Addiction_Form_module/screens/Step1AdType.dart';

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
    var list = ["Alcohol", "Tabacoo", "Drug", "Screen", "Sugar"];

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      //initialRoute: AppRoutes.loadingScreen,
      //onGenerateRoute: AppRoutes.onGenerateRoute,
      home: BlocProvider(
        create: (BuildContext context) => UserInfoCubit(),
        child: StepAddictionType(),
      ),
    );
  }
}
