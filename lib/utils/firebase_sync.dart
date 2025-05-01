// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class FirebaseSync {
  final CollectionReference<Map<String, dynamic>> _todosRef;

  FirebaseSync._(this._todosRef);

  /// Factory constructor to handle async SharedPreferences + Firestore setup
  static Future<FirebaseSync> create() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    print("👤 FirebaseSync initialized for user: $username");

    if (username == null) {
      throw Exception("🧨 No username found in SharedPreferences");
    }

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('todos');

    return FirebaseSync._(ref);
  }

  /// Upload a single todo
  Future<void> uploadTodo(Todo todo) async {
    print("🧠 Uploading '${todo.content}' to Firestore for path: ${_todosRef.path}");
    await _todosRef.doc(todo.todoId).set(todo.toJson());
  }

  /// Delete a single todo from Firestore
  Future<void> deleteTodo(String todoId) async {
    await _todosRef.doc(todoId).delete();
  }

  /// Publish all todos from local state
  Future<void> publishAll(List<Todo> todos) async {
    final batch = FirebaseFirestore.instance.batch();

    for (final todo in todos) {
      final doc = _todosRef.doc(todo.todoId);
      batch.set(doc, todo.toJson());
    }

    await batch.commit();
  }

  /// Fetch all todos for this user
  Future<List<Todo>> syncFromCloud() async {
    print("📥 Starting syncFromCloud()");
    final snapshot = await _todosRef.get();
    print("📥 Got ${snapshot.docs.length} todos from Firestore");
    return snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList();
  }
}
