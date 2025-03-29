import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/widgets/todo_category_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_project/providers/todo_provider.dart';

class AddTodo extends ConsumerWidget {
  const AddTodo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController todoController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Add Todo")),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: todoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            TodoCategoryDropdown(),
            TextButton(
              onPressed: () {
                if (todoController.text.isNotEmpty) {
                  ref.read(todoProvider.notifier).addTodo(todoController.text, stringToCategory[TodoCategoryDropdown.selectedCategory]!);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Todo"),
            ),
          ],
        ),
      ),
    );
  }
}
