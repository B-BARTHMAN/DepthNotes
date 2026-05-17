import 'package:flutter/material.dart';

class PreciseTimeFields extends StatelessWidget {
  const PreciseTimeFields({
    required this.timeIn,
    required this.timeOut,
    required this.onPickTimeIn,
    required this.onPickTimeOut,
    super.key,
  });

  final TimeOfDay? timeIn;
  final TimeOfDay? timeOut;
  final VoidCallback onPickTimeIn;
  final VoidCallback onPickTimeOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Time in'),
          subtitle: Text(timeIn?.format(context) ?? 'Tap to set'),
          trailing: const Icon(Icons.access_time),
          onTap: onPickTimeIn,
        ),
        ListTile(
          title: const Text('Time out'),
          subtitle: Text(timeOut?.format(context) ?? 'Tap to set'),
          trailing: const Icon(Icons.access_time),
          onTap: onPickTimeOut,
        ),
      ],
    );
  }
}