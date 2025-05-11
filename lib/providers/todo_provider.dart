// ignore_for_file: avoid_print

import 'dart:io';

import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/utils/firebase_todo_sync.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((ref) {
  return TodoListNotifier();
});

final isSyncingProvider = StateProvider<bool>((ref) => false);

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]) {
    state = [];
  }

  static int currId = 0;
  final Set<String> _deletedIds = {};

  Future<void> addTodo(String content, TodoCategory category) async {
    Todo newTodo = Todo(
      todoId: (currId++).toString(),
      content: content,
      isCompleted: false,
      category: category,
    );
    state = [...state, newTodo];

    try {
      if (kIsWeb || Platform.isAndroid) {
        await uploadTodo(newTodo);
      }
    } catch (e, stack) {
      print("Firebase upload failed: $e\n$stack");
    }
  }

  TodoCategory getCategory(int id) {
    return state.firstWhere((todo) => todo.todoId == id.toString()).category;
  }

  Future<void> completeTodo(int id) async {
    Todo? updatedTodo;
    state = [
      for (final todo in state)
        if (todo.todoId == id.toString())
          updatedTodo = Todo(
            todoId: todo.todoId,
            content: todo.content,
            isCompleted: true,
            category: todo.category,
          )
        else
          todo
    ];

    if (updatedTodo != null) {
      try {
        if (kIsWeb || Platform.isAndroid) {
          await uploadTodo(updatedTodo);
        }
      } catch (e, stack) {
        print("Firebase upload failed: $e\n$stack");
      }
    }
  }

  bool isComplete(int id) {
    return state.firstWhere((todo) => todo.todoId == id.toString()).isCompleted;
  }

  Future<void> deleteTodoLocal(int id) async {
    final idStr = id.toString();
    _deletedIds.add(idStr); // Track it
    state = state.where((todo) => todo.todoId != idStr).toList();
  }

  Future<void> syncFromFirebase() async {
    try {
      final todos = await downloadTodos();

      state = todos; // Overwrite local state
      _deletedIds.clear(); // Clear deleted cache

      // Recompute next ID
      final ids = todos.map((todo) => int.tryParse(todo.todoId) ?? -1).toList();
      final maxId = ids.isEmpty ? 0 : (ids.reduce((a, b) => a > b ? a : b));
      currId = maxId + 1;
    } catch (e, stack) {
      print("Firebase sync failed: $e\n$stack");
    }
  }

  Future<void> setTodos(List<Todo> newTodos) async {
    state = newTodos;

    if (newTodos.isNotEmpty) {
      final ids =
          newTodos.map((todo) => int.tryParse(todo.todoId) ?? -1).toList();
      final maxId = ids.isEmpty ? 0 : ids.reduce((a, b) => a > b ? a : b);
      currId = maxId + 1;
    } else {
      currId = 0;
    }
  }

  Future<void> publishToFirebase() async {
    try {
      // Upload all current todos to firebase
      for (final todo in state) {
        await uploadTodo(todo);
      }

      // Delete any that were removed locally
      for (final id in _deletedIds) {
        await deleteTodo(id);
      }

      _deletedIds.clear(); // Clear after publishing
    } catch (e, stack) {
      print("Publish failed: $e\n$stack");
    }
  }
}
