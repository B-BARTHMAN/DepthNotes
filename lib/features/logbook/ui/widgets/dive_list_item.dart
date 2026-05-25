import 'package:depth_notes/config/routing/app_routes.dart';
import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// One row in the logbook. Tapping pushes the detail screen.
class DiveListItem extends StatelessWidget {
  const DiveListItem({required this.dive, super.key});

  final Dive dive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(dive.site),
      subtitle: Text('${dive.depth}m · ${dive.time.duration}min'),
      trailing: Text('${dive.date.day}/${dive.date.month}/${dive.date.year}'),
      onTap: () => context.push(AppRoutes.diveDetailFor(dive.id), extra: dive),
    );
  }
}
