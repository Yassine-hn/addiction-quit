// Step6Importance.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import 'selection_step_screen.dart';
import '../models/SelectionStepConfif.dart';
import 'Step7Inclusion.dart';
import '../../../l10n/app_localizations.dart';

class Step6Importance extends StatelessWidget {
  const Step6Importance({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final currentValue = cubit.state.importanceForUser;

    return SelectionStepScreen(
      config: SelectionStepConfig(
        stepTitle: AppLocalizations.of(context)!.importance,
        screenTitle: AppLocalizations.of(context)!.personalImportance,
        mainQuestion: AppLocalizations.of(context)!.howMuchIsItImportant,
        options: [
          AppLocalizations.of(context)!.justTrying,
          AppLocalizations.of(context)!.itWouldBeGood,
          AppLocalizations.of(context)!.iNeedIt,
          AppLocalizations.of(context)!.critical,
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
