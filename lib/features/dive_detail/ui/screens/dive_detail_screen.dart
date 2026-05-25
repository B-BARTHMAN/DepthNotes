import 'package:depth_notes/config/routing/app_routes.dart';
import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive/repositories/dive_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Read-only detail view for a single dive.
///
/// Receives the [Dive] via `state.extra`, so deep-linking by URL is not
/// supported yet. The body is a placeholder — the real layout (stats,
/// photos, sightings) lands as those features ship.
class DiveDetailScreen extends StatelessWidget {
  const DiveDetailScreen({required this.dive, super.key});

  final Dive dive;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete dive?'),
        content: const Text('This can not be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    await context.read<DiveRepository>().deleteDive(dive.id);
    if (!context.mounted) return;

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dive.site),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push(AppRoutes.diveEditor, extra: dive),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: const Placeholder(), // TODO: real layout
    );
  }
}
