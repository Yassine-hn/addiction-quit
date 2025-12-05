import 'package:addiction_quit/modules/Addiction_Form_module/models/User_Info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Step2StartDate.dart';
import '../data/Cubit/UserInfoCubit.dart';
import '../data/Repositories/AddTypeRepo.dart';
import '../widgets/AddictionListItem.dart';
import '../widgets/SearchBarWidget.dart';
import '../widgets/SectionTitle.dart';
import '../widgets/ValidationButton.dart';

class StepAddictionType extends StatefulWidget {
  const StepAddictionType({super.key});

  @override
  State<StepAddictionType> createState() => _StepAddictionTypeState();
}

class _StepAddictionTypeState extends State<StepAddictionType> {
  final TextEditingController _searchController = TextEditingController();
  final AddictionTypeRepo _repo = AddictionTypeRepo();

  String? _selectedItem;
  List<String> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filteredList = _repo.data;

    // Load initial selection from cubit if exists
    final cubit = BlocProvider.of<UserInfoCubit>(context, listen: false);
    if (cubit.state.addictionType != null) {
      _selectedItem = cubit.state.addictionType;
    }
  }

  void _filterList(String value) {
    setState(() {
      if (value.isEmpty) {
        _filteredList = _repo.data;
      } else {
        _filteredList = _repo.data
            .where((e) => e.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  void _handleItemSelected(String item) {
    setState(() {
      _selectedItem = item;
    });
  }

  void _handleContinue() {
    if (_selectedItem != null) {
      context.read<UserInfoCubit>().updateAddictionType(_selectedItem!);

      //go to next screen keeping CubitProvider
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<UserInfoCubit>(),
            child: Step2StartDate(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              const SectionTitle(
                title: 'Select Addiction',
                subtitle: 'What type of addiction\ndo you want to quit?',
              ),
              const SizedBox(height: 32),

              // Search Section
              SearchBarWidget(
                controller: _searchController,
                onChanged: _filterList,
                hintText: 'Search for an addiction...',
              ),
              const SizedBox(height: 24),

              // List Section
              Expanded(child: _buildAddictionList()),
              const SizedBox(height: 24),

              // Continue Button
              ValidationButton(
                label: 'Continue',
                onPressed: () =>
                    _selectedItem != null ? _handleContinue() : null,
                enabled: _selectedItem != null,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddictionList() {
    if (_filteredList.isEmpty) {
      return const Center(
        child: Text(
          'No addictions found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _filteredList.length,
      itemBuilder: (context, index) {
        final item = _filteredList[index];
        return AddictionListItem(
          text: item,
          isSelected: item == _selectedItem,
          onTap: () => _handleItemSelected(item),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
