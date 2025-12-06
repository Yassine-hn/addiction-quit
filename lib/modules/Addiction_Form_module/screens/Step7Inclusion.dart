// Step7Inclusion.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import 'selection_step_screen.dart';
import '../models/SelectionStepConfif.dart';
import 'Step8Money.dart';

class Step7Inclusion extends StatelessWidget {
  const Step7Inclusion({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final currentValue = cubit.state.impliedPeople;

    return SelectionStepScreen(
      config: SelectionStepConfig(
        stepTitle: 'Inclusion',
        screenTitle: 'People Involved',
        mainQuestion: 'Who is involved in your journey?',
        options: const [
          'Just me',
          'My partner',
          'My family',
          'My friends',
          'My colleagues',
          'A support group',
          'My Community',
          'Everyone around me',
        ],
        selectedValue: currentValue,
      ),
      onValueSelected: (value) {
        context.read<UserInfoCubit>().updateImpliedPeople(value);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<UserInfoCubit>(),
              child: Step8Money(),
            ),
          ),
        );
      },
    );
  }
}
