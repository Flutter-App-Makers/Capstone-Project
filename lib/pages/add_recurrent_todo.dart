import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_project/providers/todo_provider.dart';

class AddRecurrentTodo extends ConsumerWidget {
  const AddRecurrentTodo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController todoController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Add Recurrent Todo")),
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
            TextButton(
              onPressed: () {
                if (todoController.text.isNotEmpty) {
                  ref.read(todoProvider.notifier).addRecurrentTodo(todoController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Recurrent Todo"),
            ),
          ],
        ),
      ),
    );
  }
}
