import 'package:flutter/material.dart';

class ParametersScreen extends StatelessWidget {
  const ParametersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parameters'),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Parameters Screen'),
      ),
    );
  }
}
