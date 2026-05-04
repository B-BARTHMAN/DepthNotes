import 'package:flutter/material.dart';

class DepthNotesApp extends StatelessWidget {
  const DepthNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Depth Notes',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006494),
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Depth Notes 🤿'),
        ),
      ),
    );
  }
}
