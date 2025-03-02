import 'package:capstone_project/widgets/active_todo_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/pages/add.dart';
import 'package:capstone_project/pages/completed.dart';
import 'package:capstone_project/providers/todo_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> activeTodos = todos.where((todo) => !todo.completed).toList();
    List<Todo> completedTodos = todos.where((todo) => todo.completed).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Todo App"),
      ),
      body: ListView.builder(
        itemCount: activeTodos.length + 1,
        itemBuilder: (context, index) {
          if (activeTodos.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: const Center(
                child: Text("Add a todo using the button below"),
              ),
            );
          }

          if (index == activeTodos.length) {
            // display completed todos
            if (completedTodos.isEmpty) {
              // TODO - something more fun
              return Container();
            } else {
              return Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CompletedTodo(),
                    ),
                  ),
                  child: Text("Completed Todos"),
                ),
              );
            }
          } else {
            return ActiveTodoSlidable(
              index: index,
              id: activeTodos[index].todoId,
              name: activeTodos[index].content,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTodo()));
        },
        tooltip: 'Increment',
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
