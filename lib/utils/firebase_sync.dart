import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo.dart';

class FirebaseSync {
  static final _todosRef =   FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .collection('todos');

  static Future<void> uploadTodo(Todo todo) async {
    await _todosRef.doc(todo.todoId).set(todo.toJson());
  }

  static Future<void> deleteTodo(String id) async {
    await _todosRef.doc(id).delete();
  }

  static Future<List<Todo>> fetchTodos() async {
    final snapshot = await _todosRef.get();
    return snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList();
  }

  static Future<void> publishAll(List<Todo> todos) async {
    // Use the correct per-user path
    final snapshot = await _todosRef.get();
    final existingIds = snapshot.docs.map((doc) => doc.id).toSet();

    // Upload current list
    for (final todo in todos) {
      await _todosRef.doc(todo.todoId.toString()).set(todo.toJson());
      existingIds.remove(todo.todoId.toString()); // no longer orphaned
    }

    // Delete cloud todos that were removed locally
    for (final orphanId in existingIds) {
      await _todosRef.doc(orphanId).delete();
    }
  }

}
