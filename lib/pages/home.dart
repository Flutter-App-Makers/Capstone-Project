import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/active_todo_list.dart';
import '../widgets/empty_todo_placeholder.dart';
import '../widgets/navigation_row.dart';
import '../widgets/home_shell.dart';
import '../providers/todo_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  // lib/pages/home.dart
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final activeTodos = todos.where((t) => !t.isCompleted).toList();
    final completedTodos = todos.where((todo) => todo.isCompleted).toList();

    return HomeShell(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: activeTodos.isEmpty && completedTodos.isEmpty
                  ? const EmptyTodoPlaceholder()
                  : ActiveTodoList(todos: activeTodos),
            ),
            const SizedBox(height: 12),
            NavigationRow(hasCompleted: completedTodos.isNotEmpty),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
