// ignore_for_file: avoid_print

import 'dart:io';

import 'package:capstone_project/pages/add_todo.dart';
import 'package:capstone_project/pages/home.dart';
import 'package:capstone_project/pages/stats.dart';
import 'package:capstone_project/root_gate.dart';
import 'package:capstone_project/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  print('Starting app...');
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb || Platform.isAndroid) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? 'Guest';
      final auth = FirebaseAuth.instance;

      // Always sign in anonymously if no current user
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }

      final user = auth.currentUser;
      if (user != null && user.displayName != username) {
        // Set the display name and then force a token refresh
        await user.updateDisplayName(username);
        await user.reload();
        await FirebaseAuth.instance.currentUser
            ?.getIdToken(true); // force refresh

        print("Updated displayName to '$username'");
      }

      print("FirebaseAuth ready for user: ${auth.currentUser?.displayName}");
    } catch (e) {
      print('Firebase init failed: $e');
    }
  }

  runApp(const ProviderScope(child: RootGate()));
  print('Running app...');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ghibliTheme,
        home: const MyHomePage(),
        routes: {
          '/addTodo': (context) => const AddTodo(),
          '/stats': (context) => const StatsPage(),
        },
      ),
    );
  }
}