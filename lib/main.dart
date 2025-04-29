import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/pages/add_recurrent_todo.dart';
import 'package:capstone_project/pages/add_todo.dart';
import 'package:capstone_project/pages/stats.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/pages/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(TodoCategoryAdapter());

  await Hive.openBox<Todo>('todos');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        home: MyHomePage(),
        routes: {
          '/addTodo': (context) => const AddTodo(),
          '/addRecurrent': (context) =>
              const AddRecurrentTodo(), // this page should exist too
          '/stats': (context) => const StatsPage(),
        },
      ),
    );
  }
}
