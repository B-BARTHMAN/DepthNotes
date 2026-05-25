import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/features/logbook/ui/widgets/dive_list_item.dart';
import 'package:flutter/material.dart';

/// Scrolling list of dives. Renders an empty state when none exist.
class DiveList extends StatelessWidget {
  const DiveList({required this.dives, super.key});

  final List<Dive> dives;

  @override
  Widget build(BuildContext context) {
    if (dives.isEmpty) {
      return const Center(child: Text('No dives yet'));
    }

    return ListView.builder(
      itemCount: dives.length,
      itemBuilder: (context, index) => DiveListItem(dive: dives[index]),
    );
  }
}
