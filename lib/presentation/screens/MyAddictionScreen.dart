// lib/screens/my_addictions_screen.dart
import 'package:flutter/material.dart';
import '../../modules/Addiction_Form_module/data/shared_preference_manager.dart';
import '../../modules/Addiction_Form_module/data/db_service.dart';
import '../../modules/Addiction_Form_module/models/User_info_model.dart';
import '../../modules/Addiction_Form_module/screens/Step1AdType.dart';

class MyAddictionsScreen extends StatefulWidget {
  const MyAddictionsScreen({super.key});

  @override
  State<MyAddictionsScreen> createState() => _MyAddictionsScreenState();
}

class _MyAddictionsScreenState extends State<MyAddictionsScreen> {
  List<Map<String, dynamic>> _addictions = [];
  bool _isLoading = true;
  int? _currentAddictionId;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadAddictions();
  }

  Future<void> _loadAddictions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _currentAddictionId = SharedPreferencesManager.getCurrentAddictionId();
      _addictions = await _databaseService.getAddictionsForCurrentUser();
    } catch (e) {
      print('Error loading addictions: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _switchAddiction(int addictionId) async {
    await _databaseService.switchAddiction(addictionId);
    setState(() {
      _currentAddictionId = addictionId;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Addiction switched'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _deleteAddiction(int addictionId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Addiction'),
        content: const Text(
          'Are you sure you want to delete this addiction? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performDelete(addictionId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete(int addictionId) async {
    try {
      await _databaseService.deleteAddiction(addictionId);
      await _loadAddictions();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Addiction deleted'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _reorderAddictions(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = _addictions.removeAt(oldIndex);
    _addictions.insert(newIndex, item);

    // Update order in database
    await _databaseService.reorderAddictions(_addictions);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addictions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAddictions,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addictions.isEmpty
          ? _buildEmptyState()
          : _buildAddictionsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddictionForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Track New Addiction'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_objects_outlined,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'No Addictions Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Start your journey by tracking your first addiction',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => _navigateToAddictionForm(context),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddictionsList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _addictions.length,
      onReorder: _reorderAddictions,
      itemBuilder: (context, index) {
        final addiction = _addictions[index];
        final isCurrent = addiction['id'] == _currentAddictionId;

        return Card(
          key: ValueKey(addiction['id']),
          margin: const EdgeInsets.only(bottom: 12),
          color: isCurrent ? Colors.blue[50] : null,
          child: ListTile(
            leading: _buildAddictionIcon(addiction['type']),
            title: Text(
              addiction['type']?.toString() ?? 'Unknown',
              style: TextStyle(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Started: ${_formatDate(addiction['start_date'])}'),
                Text('Streak: ${addiction['streak'] ?? 0} days'),
                if (addiction['goal_type'] != null)
                  Text('Goal: ${addiction['goal_type']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCurrent)
                  const Chip(
                    label: Text('Current'),
                    backgroundColor: Colors.blue,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'switch') {
                      _switchAddiction(addiction['id'] as int);
                    } else if (value == 'delete') {
                      _deleteAddiction(addiction['id'] as int);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'switch',
                      child: Row(
                        children: [
                          Icon(Icons.switch_left, size: 20),
                          SizedBox(width: 8),
                          Text('Switch to this'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddictionIcon(String? type) {
    final icon = switch (type?.toLowerCase()) {
      'alcohol' => Icons.local_drink,
      'tobacco' => Icons.smoking_rooms,
      'drug' => Icons.medical_services,
      'screen' => Icons.phone_android,
      'sugar' => Icons.cake,
      _ => Icons.help_outline,
    };

    return CircleAvatar(
      backgroundColor: Colors.blue[100],
      child: Icon(icon, color: Colors.blue),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _navigateToAddictionForm(BuildContext context) {
    // Navigate to your existing form screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StepAddictionType(), // Replace with your actual form screen
      ),
    );
  }
}
