import 'package:flutter/material.dart';

class DiveEditorScreen extends StatelessWidget {
  const DiveEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Dive')),
      body: const Center(child: Text('Dive editor')),
    );
  }
}