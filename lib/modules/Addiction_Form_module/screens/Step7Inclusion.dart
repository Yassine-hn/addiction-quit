// Step7Inclusion.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import 'selection_step_screen.dart';
import '../models/SelectionStepConfif.dart';
import 'Step8Money.dart';
import '../../../l10n/app_localizations.dart';

class Step7Inclusion extends StatelessWidget {
  const Step7Inclusion({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    final currentValue = cubit.state.impliedPeople;

    return SelectionStepScreen(
      config: SelectionStepConfig(
        stepTitle: AppLocalizations.of(context)!.inclusion,
        screenTitle: AppLocalizations.of(context)!.peopleInvolved,
        mainQuestion: AppLocalizations.of(context)!.whoIsInvolvedInYourJourney,
        options: [
          AppLocalizations.of(context)!.justMe,
          AppLocalizations.of(context)!.myPartner,
          AppLocalizations.of(context)!.myFamily,
          AppLocalizations.of(context)!.myFriends,
          AppLocalizations.of(context)!.myColleagues,
          AppLocalizations.of(context)!.aSupportGroup,
          AppLocalizations.of(context)!.myCommunity,
          AppLocalizations.of(context)!.everyoneAroundMe,
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
