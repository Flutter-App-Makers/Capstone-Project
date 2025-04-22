// lib/widgets/nav_row.dart
import 'package:flutter/material.dart';
import '../pages/completed.dart';
import '../pages/recurrent.dart';

class NavigationRow extends StatelessWidget {
  final bool hasCompleted;
  final bool hasRecurrent;

  const NavigationRow(
      {super.key, required this.hasCompleted, required this.hasRecurrent});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (hasCompleted)
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CompletedPage()),
            ),
            icon: const Icon(Icons.check),
            label: const Text("Completed"),
          ),
        if (hasRecurrent)
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecurrentPage()),
            ),
            icon: const Icon(Icons.repeat),
            label: const Text("Recurrent"),
          ),
      ],
    );
  }
}
