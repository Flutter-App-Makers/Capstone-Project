import 'package:capstone_project/providers/todo_provider.dart';
import 'package:capstone_project/utils/category_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoListTile extends ConsumerWidget {
  final int id;
  final String name;

  const TodoListTile({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(name),
      trailing: Icon(
        Icons.check_circle,
        color: ref.watch(todoProvider.notifier).isComplete(id)
            ? Colors.green
            : Colors.grey,
      ),
      leading: Icon(
        categoryIcons[ref.watch(todoProvider.notifier).getCategory(id)] ??
            Icons.label,
        color:
            categoryColors[ref.watch(todoProvider.notifier).getCategory(id)] ??
                Colors.grey,
        size: 30,
      ),
    );
  }
}