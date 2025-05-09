// lib/widgets/nav_row.dart
import 'package:capstone_project/pages/recurrent_task.dart';
import 'package:flutter/material.dart';
import '../pages/completed.dart';

class NavigationRow extends StatelessWidget {
  final bool hasCompleted;

  const NavigationRow(
      {super.key, required this.hasCompleted});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecurrentTasksPage(),
              ),
            );
          },
          child: const Text('Recurrent Tasks'),
        ),
        if (hasCompleted)
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CompletedPage()),
            ),
            icon: const Icon(Icons.check),
            label: const Text("Completed"),
          ),
      ],
    );
  }
}
