// ignore_for_file: avoid_print, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/todo.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: deprecated_member_use
import 'dart:html' as html;

Future<String> getLocalPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> getTodoFile() async {
  final path = await getLocalPath();
  return File('$path/todos.json');
}

Future<File?> exportTodos(List<Todo> todos) async {
  if (kIsWeb) {
    exportTodosWeb(todos);
    return null;
  }
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

    if (result != null &&
        result.files.isNotEmpty &&
        result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      print("📄 Loaded file content: $content");
      final List<dynamic> decoded = jsonDecode(content);
      return decoded.map((json) => Todo.fromJson(json)).toList();
    } else {
      print('❌ No file selected.');
    }
  } catch (e) {
    print('❌ Failed to import todos: $e');
  }
  return null;
}

void exportTodosWeb(List<Todo> todos) {
  final json = jsonEncode(todos.map((t) => t.toJson()).toList());
  final blob = html.Blob([json], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', 'todos.json')
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<List<Todo>?> importTodosWeb() async {
  final completer = Completer<List<Todo>?>();
  final input = html.FileUploadInputElement()..accept = '.json';

  input.onChange.listen((_) {
    final file = input.files?.first;
    if (file == null) {
      completer.complete(null);
      return;
    }

    final reader = html.FileReader();
    reader.readAsText(file);

    reader.onLoad.listen((_) {
      try {
        final content = reader.result as String;
        print("📄 Loaded file content: $content");
        final List<dynamic> decoded = jsonDecode(content);
        try {
          final todos = decoded.map((e) => Todo.fromJson(e)).toList();
          completer.complete(todos.cast<Todo>());
        } catch (e) {
          print("❌ Failed during fromJson parsing: $e");
          completer.complete(null);
        }
      } catch (e) {
        print('❌ Failed to parse JSON: $e');
        completer.complete(null);
      }
    });

    reader.onError.listen((_) {
      completer.complete(null);
    });
  });

  input.click();
  return completer.future;
}
