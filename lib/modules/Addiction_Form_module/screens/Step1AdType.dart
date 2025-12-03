import 'package:addiction_quit/modules/Addiction_Form_module/models/User_Info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/Cubit/UserInfoCubit.dart';
import '../widgets/SectionTitle.dart';
import '../widgets/SearchListWidget.dart';
import '../data/Repositories/AddTypeRepo.dart';

class StepAddictionType extends StatelessWidget {
  const StepAddictionType({super.key});

  @override
  Widget build(BuildContext context) {
    final addictionTypeRepo = AddictionTypeRepo();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Addiction Type'),
        backgroundColor: const Color.fromARGB(255, 0, 9, 180),
      ),
      body: BlocBuilder<UserInfoCubit, UserInfoModel>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(text: 'What are you addicted to?'),
                const SizedBox(height: 8),
                const Text(
                  'Select the main substance or behavior you want to address',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                SearchListWidget(
                  items: addictionTypeRepo.data,
                  initialSelection: state.addictionType,
                  onSelected: (selectedType) {
                    // Update the cubit state
                    context.read<UserInfoCubit>().updateAddictionType(
                      selectedType,
                    );

                    // Show confirmation and navigate back
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: $selectedType'),
                        duration: const Duration(seconds: 1),
                      ),
                    );

                    // Navigate back after a short delay
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      Navigator.pop(context);
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Current selection indicator
                if (state.addictionType != null &&
                    state.addictionType!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 236, 255),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 9, 180),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color.fromARGB(255, 0, 9, 180),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Current selection: ${state.addictionType}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 0, 9, 180),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
