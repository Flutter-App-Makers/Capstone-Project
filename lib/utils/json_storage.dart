// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
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

Future<File?> exportTodos(List<Todo> todos) async {
  try {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save your todos.json file',
      fileName: 'todos.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (path == null) return null; // User canceled

    final file = File(path);
    final json = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    return await file.writeAsString(json);
  } catch (e) {
    print('❌ Failed to export todos: $e');
    return null;
  }
}

Future<List<Todo>?> importTodos() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(content);
      return decoded.map((json) => Todo.fromJson(json)).toList();
    } else {
      print('❌ No file selected.');
      return null; // 🔁 return null instead of []
    }
  } catch (e) {
    print('❌ Failed to import todos: $e');
    return null;
  }
}
