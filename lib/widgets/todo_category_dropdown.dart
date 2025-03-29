import 'package:capstone_project/models/todo.dart';
import 'package:flutter/material.dart';

class TodoCategoryDropdown extends StatelessWidget {
  static List<String> categories = stringToCategory.keys.toList();
  static String selectedCategory = categories[0];

  const TodoCategoryDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: categories[0],
      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          selectedCategory = newValue;
        }
      },
      decoration: InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
      ),
    );
  }
}
