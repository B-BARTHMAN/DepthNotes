import 'package:depth_notes/config/routing/app_router.dart';
import 'package:depth_notes/config/theme/app_theme.dart';
import 'package:depth_notes/core/dive/repositories/dive_repository.dart';
import 'package:depth_notes/core/dive/services/local_dive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepthNotesApp extends StatelessWidget {
  const DepthNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => DiveRepository(
        localDiveService: LocalDiveService(),
      ),
      child: MaterialApp.router(
        title: 'Depth Notes',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
