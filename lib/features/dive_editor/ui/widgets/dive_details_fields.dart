import 'package:flutter/material.dart';

/// Site, depth, and notes fields. Depth is metric.
class DiveDetailsFields extends StatelessWidget {
  const DiveDetailsFields({
    required this.siteController,
    required this.depthController,
    required this.notesController,
    super.key,
  });

  final TextEditingController siteController;
  final TextEditingController depthController;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: siteController,
          decoration: const InputDecoration(labelText: 'Dive site'),
          textCapitalization: TextCapitalization.words,
          validator: (value) =>
              value == null || value.isEmpty ? 'Enter a dive site' : null,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: depthController,
          decoration: const InputDecoration(
            labelText: 'Max depth',
            suffixText: 'm',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            final depth = double.tryParse(value ?? '');
            if (depth == null || depth <= 0) return 'Enter a valid depth';
            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: notesController,
          decoration: const InputDecoration(labelText: 'Notes'),
          maxLines: 3,
        ),
      ],
    );
  }
}
