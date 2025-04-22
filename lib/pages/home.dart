// lib/pages/home.dart
import 'package:capstone_project/widgets/active_todo_list.dart';
import 'package:capstone_project/widgets/empty_todo_placeholder.dart';
import 'package:capstone_project/widgets/navigation_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/home_shell.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final activeTodos =
        todos.where((t) => !t.completed && !t.recurrent).toList();
    final completedTodos =
        todos.where((todo) => todo.completed && !todo.recurrent).toList();
    final recurrentTodos = todos.where((todo) => todo.recurrent).toList();

    return HomeShell(
      body: activeTodos.isEmpty &&
              completedTodos.isEmpty &&
              recurrentTodos.isEmpty
          ? const EmptyTodoPlaceholder()
          : Column(
              children: [
                Expanded(child: ActiveTodoList(todos: activeTodos)),
                if (completedTodos.isNotEmpty || recurrentTodos.isNotEmpty)
                  NavigationRow(
                    hasCompleted: completedTodos.isNotEmpty,
                    hasRecurrent: recurrentTodos.isNotEmpty,
                  ),
              ],
            ),
    );
  }
}
