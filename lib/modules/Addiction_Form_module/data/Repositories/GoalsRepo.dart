// GoalsRepo.dart - Repository for goals
class GoalsRepo {
  final List<String> _goals = [
    'For my family',
    'For legal issues',
    'For my religion',
    'To feel better in my skin',
    'For my health',
    'To improve my finances',
    'To be more productive',
    'To save money',
    'To improve relationships',
    'For my career',
    'To gain self-control',
    'To be a better example',
    'To reduce stress',
    'To improve sleep',
    'To increase energy',
  ];

  List<String> get data => List.unmodifiable(_goals);

  List<String> searchGoals(String query) {
    if (query.isEmpty) return _goals;
    return _goals
        .where((goal) => goal.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
