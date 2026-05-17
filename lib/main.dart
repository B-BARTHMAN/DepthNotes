import 'package:depth_notes/app.dart';
import 'package:depth_notes/core/database/app_database.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase(driftDatabase(name: 'depth_notes'));
  runApp(DepthNotesApp(database: database));
}
