import 'package:flutter/material.dart';

/// Tappable tile that opens a date picker.
class DatePickerTile extends StatelessWidget {
  const DatePickerTile({
    required this.date,
    required this.onDateChanged,
    super.key,
  });

  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Date'),
      subtitle: Text('${date.day}/${date.month}/${date.year}'),
      trailing: const Icon(Icons.calendar_today),
      onTap: () => _pick(context),
    );
  }
}
