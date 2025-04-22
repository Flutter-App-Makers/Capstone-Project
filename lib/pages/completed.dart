import 'package:capstone_project/widgets/completed_todo_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/providers/todo_provider.dart';

class CompletedPage extends ConsumerWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> completedTodos =
        todos.where((todo) => todo.completed && !todo.recurrent).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Todo App"),
      ),
      body: ListView.builder(
          itemCount: completedTodos.length,
          itemBuilder: (context, index) {
            return RecurrentTodoSlidable(
              id: completedTodos[index].todoId,
              name: completedTodos[index].content,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CompletedPage()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
