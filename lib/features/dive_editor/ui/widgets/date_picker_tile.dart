import 'package:flutter/material.dart';

class DatePickerTile extends StatelessWidget {
  const DatePickerTile({
    required this.date,
    required this.onPick,
    super.key,
  });

  final DateTime date;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Date'),
      subtitle: Text('${date.day}/${date.month}/${date.year}'),
      trailing: const Icon(Icons.calendar_today),
      onTap: onPick,
    );
  }
}
