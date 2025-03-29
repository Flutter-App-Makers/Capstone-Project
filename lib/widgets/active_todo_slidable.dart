import 'package:capstone_project/providers/todo_provider.dart';
import 'package:capstone_project/widgets/todo_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ActiveTodoSlidable extends ConsumerWidget {
  final int id;
  final String name;

  const ActiveTodoSlidable({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                ref.watch(todoProvider.notifier).deleteTodo(id),
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                ref.watch(todoProvider.notifier).completeTodo(id),
            backgroundColor: Colors.green,
            icon: Icons.check,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          )
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: TodoListTile(
          id: id,
          name: name,
        ),
      ),
    );
  }
}
