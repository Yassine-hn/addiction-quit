// Step6Importance.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import 'selection_step_screen.dart';
import '../models/SelectionStepConfif.dart';
import 'Step7Inclusion.dart';

class Step6Importance extends StatelessWidget {
  const Step6Importance({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final currentValue = cubit.state.importanceForUser;

    return SelectionStepScreen(
      config: SelectionStepConfig(
        stepTitle: 'Importance',
        screenTitle: 'Personal Importance',
        mainQuestion: 'How much is it important for you?',
        options: const [
          'Just trying',
          'It would be good',
          'I need it',
          'Critical',
        ],
        selectedValue: currentValue,
      ),
      onValueSelected: (value) {
        context.read<UserInfoCubit>().updateImportanceForUser(value);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<UserInfoCubit>(),
              child: Step7Inclusion(),
            ),
          ),
        );
      },
    );
  }
}
