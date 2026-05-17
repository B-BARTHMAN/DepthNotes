import 'package:flutter/material.dart';

class DiveStats extends StatelessWidget {
  const DiveStats({
    required this.totalDives,
    required this.totalDuration, 
    super.key,
  });

  final int totalDives;
  final int totalDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('$totalDives dives'),
          Text('$totalDuration min underwater')
        ],
      ),
    );
  }
}
