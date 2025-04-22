// lib/widgets/todo_category_dropdown.dart
import 'package:capstone_project/models/todo.dart';
import 'package:flutter/material.dart';

class TodoCategoryDropdown extends StatelessWidget {
  final TodoCategory selected;
  final ValueChanged<TodoCategory> onChanged;

  const TodoCategoryDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TodoCategory>(
      value: selected,
      items: TodoCategory.values.map((TodoCategory category) {
        return DropdownMenuItem<TodoCategory>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (TodoCategory? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      decoration: const InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
      ),
    );
  }
}
