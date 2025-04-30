// ignore_for_file: avoid_print

import 'dart:io';

import 'package:capstone_project/utils/firebase_sync.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_project/models/todo.dart';
import 'package:hive/hive.dart';

final todoProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((ref) {
  return TodoListNotifier();
});

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]) {
    // Load existing todos from Hive
    final box = Hive.box<Todo>('todos');
    final existingTodos = box.values.toList();
    state = existingTodos;
  }
  static int currId = 0;

  Future<void> addTodo(String content, TodoCategory category) async {
    Todo newTodo = Todo(
      todoId: (currId++).toString(),
      content: content,
      isCompleted: false,
      category: category,
    );
    state = [...state, newTodo];
    Hive.box<Todo>('todos').add(newTodo);

    // ☁️ Upload to Firebase
    try {
      if (kIsWeb || Platform.isAndroid) {
        await FirebaseSync.uploadTodo(newTodo);
      }
    } catch (e) {
      print("Firebase update failed: $e");
    }
  }


  Future<void> addRecurrentTodo(String content, TodoCategory category) async {
    Todo newTodo = Todo(
      todoId: (currId++).toString(),
      content: content,
      isCompleted: false,
      recurrent: true,
      category: category,
    );
    state = [...state, newTodo];
    Hive.box<Todo>('todos').add(newTodo);

    // ☁️ Upload to Firebase
    try {
      if (kIsWeb || Platform.isAndroid) {
        await FirebaseSync.uploadTodo(newTodo);
      }
    } catch (e) {
      print("Firebase update failed: $e");
    }
  }

  TodoCategory getCategory(int id) {
    return state.firstWhere((todo) => todo.todoId == id.toString()).category;
  }

  Future<void> completeTodo(int id) async {
    Todo? updatedTodo;

    state = [ // The new state has all the same todos except the one we want to update
      for (final todo in state)
        if (todo.todoId == id.toString())
          updatedTodo = Todo(
            todoId: todo.todoId,
            content: todo.content,
            isCompleted: true,
            recurrent: todo.recurrent,
            category: todo.category,
          )
        else
          todo
    ];

    final box = Hive.box<Todo>('todos');
    final todoToComplete = box.values.firstWhere(
      (todo) => todo.todoId == id.toString(),
    );

    todoToComplete.isCompleted = true;
    await todoToComplete.save(); // 🛡️ persist to Hive

    // ☁️ Upload to Firebase
    if (updatedTodo != null) {
      try {
        if (kIsWeb || Platform.isAndroid) {
          await FirebaseSync.uploadTodo(updatedTodo);
        }
      } catch (e) {
        print("Firebase update failed: $e");
      }
    }
  }


  bool isComplete(int id) {
    return state.firstWhere((todo) => todo.todoId == id.toString()).isCompleted;
  }

  Future<void> deleteTodo(int id) async {
    final box = Hive.box<Todo>('todos');
    final todoToDelete = box.values.firstWhere(
      (todo) => todo.todoId == id.toString(),
    );
    todoToDelete.delete();

    state = state.where((todo) => todo.todoId != id.toString()).toList();
  }

  Future<void> syncFromFirebase() async {
    try {
      final todos = await FirebaseSync.fetchTodos();
      state = todos;

      // Optional: Overwrite Hive
      final box = Hive.box<Todo>('todos');
      await box.clear();
      for (var todo in todos) {
        await box.add(todo);
      }

      // Update ID counter
      final ids = todos.map((todo) => int.tryParse(todo.todoId) ?? -1).toList();
      final maxId = ids.isEmpty ? 0 : (ids.reduce((a, b) => a > b ? a : b));
      currId = maxId + 1;
    } catch (e) {
      print("Firebase fetch failed: $e");
    }
  }

  Future<void> setTodos(List<Todo> newTodos) async {
    state = newTodos;

    // Set currId safely based on imported todos
    if (newTodos.isNotEmpty) {
      final ids =
          newTodos.map((todo) => int.tryParse(todo.todoId) ?? -1).toList();
      final maxId = ids.isEmpty ? 0 : (ids.reduce((a, b) => a > b ? a : b));
      currId = maxId + 1;
    } else {
      currId = 0;
    }
  }
}
