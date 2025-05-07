// lib/pages/stats.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../widgets/catchable_fish.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final completedTodos = todos.where((t) => t.isCompleted).toList();
    final total = todos.length;
    final completed = completedTodos.length;
    final completionRate = total == 0 ? 0 : ((completed / total) * 100).round();
    final random = Random();

    return Scaffold(
      appBar: AppBar(title: const Text("Stats")),
      body: Stack(
        children: [
          // 🎨 Totoro forest & cloud decorations
          ...List.generate(4, (i) {
            final left = random.nextDouble() * MediaQuery.of(context).size.width;
            final top = random.nextDouble() * MediaQuery.of(context).size.height;
            final asset = i % 2 == 0
                ? 'assets/ghibli_cloud.png'
                : 'assets/totoro_forest.png';
            final size = 100.0 + random.nextDouble() * 80;
            return Positioned(
              left: left,
              top: top,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(asset, width: size),
              ),
            );
          }),

          // 🎣 Animated fish for completed tasks
          ...List.generate(completedTodos.length, (i) {
            final double spacing = MediaQuery.of(context).size.height /
                (completedTodos.length + 1);
            return CatchableFish(
              key: ValueKey("completed_fish_${completedTodos[i].todoId}"),
              center: Offset(
                80 + Random(i).nextDouble() * 200,
                spacing * (i + 1),
              ),
              radius: 20,
              swimDuration: Duration(seconds: 5 + i % 3),
              onCaught: null, // no catching on stats screen
            );
          }),

          // 📊 Stats panel
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📋 Total Tasks: $total",
                    style: Theme.of(context).textTheme.titleMedium),
                Text("✅ Completed: $completed",
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
        ],
      ),
    );
  }
}
