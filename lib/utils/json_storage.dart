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
  final file = await getTodoFile();
  final jsonList = todos.map((todo) => todo.toJson()).toList();
  await file.writeAsString(jsonEncode(jsonList));
}

Future<List<Todo>> importTodos() async {
  final file = await getTodoFile();
  if (!await file.exists()) return [];
  final content = await file.readAsString();
  final List<dynamic> decoded = jsonDecode(content);
  return decoded.map((json) => Todo.fromJson(json)).toList();
}