// lib/widgets/active_list.dart
import 'package:flutter/material.dart';
import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/widgets/active_todo_slidable.dart';

class ActiveTodoList extends StatelessWidget {
  final List<Todo> todos;
  const ActiveTodoList({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ActiveTodoSlidable(id: todo.todoId, name: todo.content),
        );
      },
    );
  }
}
