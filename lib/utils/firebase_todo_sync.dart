// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

final _firestore = FirebaseFirestore.instance;

Future<CollectionReference<Map<String, dynamic>>>
    getUserTodoCollection() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  if (username == null) throw Exception("No username in SharedPreferences");

  return _firestore.collection('users').doc(username).collection('todos');
}

Future<void> uploadTodo(Todo todo) async {
  print("Uploading '${todo.content}' to Firestore");
  final collection = await getUserTodoCollection();
  await collection.doc(todo.todoId).set(todo.toJson());
}

Future<void> deleteTodo(String id) async {
  print("Deleting todo $id from Firestore");
  final collection = await getUserTodoCollection();
  await collection.doc(id).delete();
}

Future<List<Todo>> downloadTodos() async {
  print("Starting syncFromCloud()");
  final collection = await getUserTodoCollection();
  final snapshot = await collection.get();
  print("Got ${snapshot.docs.length} todos from Firestore");
  return snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList();
}