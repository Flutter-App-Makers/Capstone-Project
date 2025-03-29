import 'package:capstone_project/pages/add_recurrent_todo.dart';
import 'package:capstone_project/pages/recurrent.dart';
import 'package:capstone_project/widgets/active_todo_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/pages/add_todo.dart';
import 'package:capstone_project/pages/completed.dart';
import 'package:capstone_project/providers/todo_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> activeTodos =
        todos.where((todo) => !todo.completed && !todo.recurrent).toList();
    List<Todo> completedTodos =
        todos.where((todo) => todo.completed && !todo.recurrent).toList();
    List<Todo> recurrentTodos = todos.where((todo) => todo.recurrent).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Todo App"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: activeTodos.length + 1,
          itemBuilder: (context, index) {
            if (activeTodos.isEmpty &&
                recurrentTodos.isEmpty &&
                completedTodos.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: const Center(
                  child: Text("Add a todo using the button below"),
                ),
              );
            } else if (index == activeTodos.length) {
              // Finished displaying all of the active todos
              if (completedTodos.isNotEmpty && recurrentTodos.isNotEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CompletedTodos(),
                          ),
                        ),
                        child: Text("Completed Todos"),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RecurrentTodos(),
                          ),
                        ),
                        child: Text("Recurrent Todos"),
                      ),
                    ),
                  ],
                );
              } else if (completedTodos.isNotEmpty) {
                return Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CompletedTodos(),
                      ),
                    ),
                    child: Text("Completed Todos"),
                  ),
                );
              } else if (recurrentTodos.isNotEmpty) {
                return Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RecurrentTodos(),
                      ),
                    ),
                    child: Text("Recurrent Todos"),
                  ),
                );
              }
            } else {
              // Display active todos
              return ActiveTodoSlidable(
                id: activeTodos[index].todoId,
                name: activeTodos[index].content,
              );
            }
            return null;
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddTodo()));
            },
            tooltip: 'Add Todo',
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddRecurrentTodo()));
            },
            tooltip: 'Add Recurrent Todo',
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
