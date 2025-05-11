import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/widgets/todo_category_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_project/providers/todo_provider.dart';

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  final TextEditingController todoController = TextEditingController();
  TodoCategory _selectedCategory = TodoCategory.work;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add TODO")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: todoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'What are we TODO?',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TodoCategoryDropdown(
                    selected: _selectedCategory,
                    onChanged: (newCat) {
                      setState(() {
                        _selectedCategory = newCat;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final text = todoController.text.trim();
                      if (text.isEmpty) return;

                      ref.read(todoProvider.notifier).addTodo(
                            text,
                            _selectedCategory,
                          );

                      Navigator.pop(context);
                    },
                    child: const Text('Add TODO'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}