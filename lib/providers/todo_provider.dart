// ignore_for_file: avoid_print

import 'dart:io';

import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/utils/firebase_sync.dart';
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
  final Set<String> _deletedIds = {}; // ✅ Track deleted IDs

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
        final firebaseSync = await FirebaseSync.create();
        await firebaseSync.uploadTodo(newTodo);
      }
    } catch (e, stack) {
      print("🔥 Firebase upload failed: $e\n$stack");
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
          final firebaseSync = await FirebaseSync.create();
          await firebaseSync.uploadTodo(updatedTodo);
        }
      } catch (e, stack) {
        print("🔥 Firebase upload failed: $e\n$stack");
      }
    }
  }

  bool isComplete(int id) {
    return state.firstWhere((todo) => todo.todoId == id.toString()).isCompleted;
  }

  Future<void> deleteTodo(int id) async {
    state = state.where((todo) => todo.todoId != id.toString()).toList();
  }

  Future<void> syncFromFirebase() async {
    try {
      final firebaseSync = await FirebaseSync.create();
      final todos = await firebaseSync.syncFromCloud();
      state = todos;

      final ids = todos.map((todo) => int.tryParse(todo.todoId) ?? -1).toList();
      final maxId = ids.isEmpty ? 0 : (ids.reduce((a, b) => a > b ? a : b));
      currId = maxId + 1;
    } catch (e, stack) {
      print("🔥 Firebase upload failed: $e\n$stack");
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
    final firebase = await FirebaseSync.create();
    await firebase.publishAll(state);

    for (final id in _deletedIds) {
      await firebase.deleteTodo(id);
    }
    _deletedIds.clear(); // ✅ Done
  }
}
