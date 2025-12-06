import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/ValidationButton.dart';
import 'Step1AdType.dart';
import '../data/Cubit/UserInfoCubit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Welcome_screen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Aboard!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: "You've taken the first and most important\n",
                      ),
                      TextSpan(
                        text: "step. We're here to support you on your\n",
                      ),
                      TextSpan(text: "path to a healthier life."),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                ValidationButton(
                  label: 'Start My Journey',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<UserInfoCubit>(),
                          child: StepAddictionType(),
                        ),
                      ),
                    );
                  },
                  enabled: true,
                  fullWidth: true,
                  height: 56.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
