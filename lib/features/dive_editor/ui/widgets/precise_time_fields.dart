import 'package:depth_notes/core/dive/models/dive_time.dart';
import 'package:flutter/material.dart';

/// Inputs for [DiveTime.precise]: timeIn / timeOut pickers.
class PreciseTimeFields extends StatelessWidget {
  const PreciseTimeFields({
    required this.timeIn,
    required this.timeOut,
    required this.onTimeInChanged,
    required this.onTimeOutChanged,
    super.key,
  });

  final TimeOfDay? timeIn;
  final TimeOfDay? timeOut;
  final ValueChanged<TimeOfDay> onTimeInChanged;
  final ValueChanged<TimeOfDay> onTimeOutChanged;

  Future<void> _pick(
    BuildContext context, {
    required TimeOfDay? initial,
    required ValueChanged<TimeOfDay> onChanged,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Time in'),
          subtitle: Text(timeIn?.format(context) ?? 'Tap to set'),
          trailing: const Icon(Icons.access_time),
          onTap: () =>
              _pick(context, initial: timeIn, onChanged: onTimeInChanged),
        ),
        ListTile(
          title: const Text('Time out'),
          subtitle: Text(timeOut?.format(context) ?? 'Tap to set'),
          trailing: const Icon(Icons.access_time),
          onTap: () =>
              _pick(context, initial: timeOut, onChanged: onTimeOutChanged),
        ),
      ],
    );
  }
}
