import 'package:depth_notes/config/routing/app_routes.dart';
import 'package:depth_notes/features/logbook/cubit/dive_log_cubit.dart';
import 'package:depth_notes/features/logbook/cubit/dive_log_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LogbookScreen extends StatelessWidget {
  const LogbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logbook')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.diveEditor),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<DiveLogCubit, DiveLogState>(
        builder: (context, state) {
          return switch (state.status) {
            DiveLogStatus.initial ||
            DiveLogStatus.loading => 
              const Center(
                child: CircularProgressIndicator(),
              ),
            DiveLogStatus.failure => Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            ),
            DiveLogStatus.success => ListView.builder(
              itemCount: state.dives.length,
              itemBuilder: (context, index) {
                final dive = state.dives[index];
                return ListTile(
                  title: Text(dive.site),
                  subtitle: Text('${dive.depth}m · ${dive.duration}min'),
                  trailing: Text('${dive.date.day}/${dive.date.month}/${dive.date.year}'),
                );
              },
            )
          };
        },
      )
    );
  }
}
