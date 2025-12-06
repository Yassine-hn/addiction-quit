// selection_step_config.dart - Configuration model for the selection screen
class SelectionStepConfig {
  final String stepTitle;
  final String mainQuestion;
  final List<String> options;
  final String? selectedValue;
  final String? screenTitle;

  const SelectionStepConfig({
    required this.stepTitle,
    required this.mainQuestion,
    required this.options,
    this.selectedValue,
    this.screenTitle,
  });
}
