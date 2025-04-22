// lib/pages/add_recurrent_todo.dart
import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/widgets/todo_category_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_project/providers/todo_provider.dart';

class AddRecurrentTodo extends ConsumerStatefulWidget {
  const AddRecurrentTodo({super.key});

  @override
  ConsumerState<AddRecurrentTodo> createState() => _AddRecurrentTodoState();
}

class _AddRecurrentTodoState extends ConsumerState<AddRecurrentTodo> {
  final TextEditingController todoController = TextEditingController();
  TodoCategory _selectedCategory = TodoCategory.work;

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TodoCategoryDropdown(
                selected: _selectedCategory,
                onChanged: (newCat) {
                  setState(() {
                    _selectedCategory = newCat;
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () {
                if (todoController.text.isNotEmpty) {
                  ref.read(todoProvider.notifier).addRecurrentTodo(
                        todoController.text,
                        _selectedCategory,
                      );
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
