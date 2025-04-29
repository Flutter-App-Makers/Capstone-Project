// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/todo.dart';

Future<String> getLocalPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> getTodoFile() async {
  final path = await getLocalPath();
  return File('$path/todos.json');
}

Future<void> exportTodos(List<Todo> todos) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/todos.json');
    final json = jsonEncode(todos.map((todo) => todo.toJson()).toList());

    await file.writeAsString(json);
    print('✅ Exported todos to: ${file.path}');
  } catch (e) {
    print('❌ Failed to export todos: $e');
  }
}

Future<List<Todo>> importTodos() async {
  final file = await getTodoFile();
  if (!await file.exists()) return [];
  final content = await file.readAsString();
  final List<dynamic> decoded = jsonDecode(content);
  return decoded.map((json) => Todo.fromJson(json)).toList();
}