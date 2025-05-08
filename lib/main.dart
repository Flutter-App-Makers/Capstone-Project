// ignore_for_file: avoid_print

import 'dart:io';

import 'package:capstone_project/models/todo.dart';
import 'package:capstone_project/pages/add_todo.dart';
import 'package:capstone_project/pages/stats.dart';
import 'package:capstone_project/root_gate.dart';
import 'package:capstone_project/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/pages/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  print('🔥 Starting app...');
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb || Platform.isAndroid) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseAuth.instance.signInAnonymously();
      print('✅ Signed in anonymously');
    } catch (e) {
      print('Firebase init failed :-(: $e');
    }
  }

  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(TodoCategoryAdapter());
  await Hive.openBox<Todo>('todos');

  runApp(const ProviderScope(child: RootGate()));
  print('🟢 Running app...');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ghibliTheme,
        home: MyHomePage(),
        routes: {
          '/addTodo': (context) => const AddTodo(),
          '/stats': (context) => const StatsPage(),
        },
      ),
    );
  }
}
