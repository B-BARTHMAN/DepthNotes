
import 'package:depth_notes/core/dive/models/dive_time.dart';
import 'package:flutter/material.dart';

class RoughTimeFields extends StatelessWidget {
  const RoughTimeFields({
    required this.timeOfDay,
    required this.onTimeOfDayChanged,
    required this.durationController,
    super.key,
  });

  final DiveTimeOfDay timeOfDay;
  final ValueChanged<DiveTimeOfDay> onTimeOfDayChanged;
  final TextEditingController durationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        DropdownButtonFormField<DiveTimeOfDay>(
          initialValue: timeOfDay,
          decoration: const InputDecoration(labelText: 'Time of day'),
          items: DiveTimeOfDay.values.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onTimeOfDayChanged(value);
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: durationController,
          decoration: const InputDecoration(
            labelText: 'Duration',
            suffixText: 'min'
          ),
          keyboardType: TextInputType.number,
        ),

      ],
    );
  }
}
