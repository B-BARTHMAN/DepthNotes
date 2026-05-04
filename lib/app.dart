import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepthNotesApp extends ConsumerWidget {
  const DepthNotesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
