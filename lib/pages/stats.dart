// lib/pages/stats.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final total = todos.length;
    final completed = todos.where((t) => t.isCompleted).length;
    final recurrent = todos.where((t) => t.recurrent).length;
    final completionRate = total == 0 ? 0 : ((completed / total) * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text("Stats")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📋 Total Tasks: $total",
                style: Theme.of(context).textTheme.titleMedium),
            Text("✅ Completed: $completed",
                style: Theme.of(context).textTheme.titleMedium),
            Text("🔁 Recurrent: $recurrent",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: total == 0 ? 0 : completed / total,
              minHeight: 10,
            ),
            const SizedBox(height: 10),
            Text(
              "🎯 Completion Rate: $completionRate%",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
