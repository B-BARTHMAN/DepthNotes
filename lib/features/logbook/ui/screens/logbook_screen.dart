import 'package:depth_notes/config/routing/app_routes.dart';
import 'package:depth_notes/features/logbook/cubit/dive_log_cubit.dart';
import 'package:depth_notes/features/logbook/cubit/dive_log_state.dart';
import 'package:depth_notes/features/logbook/cubit/dive_log_stats.dart';
import 'package:depth_notes/features/logbook/ui/widgets/dive_list.dart';
import 'package:depth_notes/features/logbook/ui/widgets/dive_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Logbook tab. Header stats + the dive list, with a FAB to log a new one.
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
            DiveLogStatus.initial || DiveLogStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            DiveLogStatus.failure => Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            ),
            DiveLogStatus.success => Column(
              children: [
                DiveStats(
                  totalDives: state.totalDives,
                  totalDuration: state.totalDuration,
                ),
                Expanded(child: DiveList(dives: state.dives)),
              ],
            ),
          };
        },
      ),
    );
  }
}
