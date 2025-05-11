import 'dart:math';
import 'package:capstone_project/providers/todo_provider.dart';
import 'package:capstone_project/widgets/catchable_fish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final random = Random();

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final completedTodos = todos.where((t) => t.isCompleted).toList();
    final total = todos.length;
    final completed = completedTodos.length;
    final completionRate = total == 0 ? 0 : ((completed / total) * 100).round();

    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final fishSize = isSmallScreen ? 40.0 : 70.0;
    final visibleFish =
        isSmallScreen ? completedTodos.take(6).toList() : completedTodos;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Stats")),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Ghibli art
            ...List.generate(4, (i) {
              final left = random.nextDouble() * screenSize.width;
              final top = random.nextDouble() * screenSize.height;
              final asset = i % 2 == 0
                  ? 'assets/ghibli_cloud.png'
                  : 'assets/totoro_forest.png';
              final size = 100.0 + random.nextDouble() * 80;
              return Positioned(
                left: left,
                top: top,
                child: Image.asset(asset, width: size),
              );
            }),

            // Statistics page
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Completed $completed of $total tasks",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "$completionRate%",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                  ),
                ],
              ),
            ),

            // Fish float over everything
            IgnorePointer(
              child: Stack(
                children: visibleFish.map((todo) {
                  final dx = random.nextDouble() * screenSize.width;
                  final dy = random.nextDouble() * screenSize.height;
                  return CatchableFish(
                      center: Offset(dx, dy), radius: fishSize);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}