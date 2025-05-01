import 'package:capstone_project/main.dart';
import 'package:capstone_project/pages/name_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  Future<bool> hasUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasUsername(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.data == true) {
          return const MyApp();
        } else {
          return const MaterialApp(home: NameEntryScreen());
        }
      },
    );
  }
}
