import 'package:flutter/material.dart';

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
    required ValueChanged<TimeOfDay> onChanged,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
          onTap: () => _pick(context, onChanged: onTimeInChanged),
        ),
        ListTile(
          title: const Text('Time out'),
          subtitle: Text(timeOut?.format(context) ?? 'Tap to set'),
          trailing: const Icon(Icons.access_time),
          onTap: () => _pick(context, onChanged: onTimeOutChanged),
        ),
      ],
    );
  }
}
