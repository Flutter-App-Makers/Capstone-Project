import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // Replace with the file that defines MyApp

class NameEntryScreen extends StatefulWidget {
  const NameEntryScreen({super.key});

  @override
  State<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends State<NameEntryScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  Future<void> _submitName() async {
    final name = _controller.text.trim();

    if (name.isEmpty || name.length < 2) {
      setState(() {
        _error = "Please enter a valid name (2+ characters)";
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);

    // Jump into the main app!
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => const MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Your Name")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome! What's your name?",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "e.g. Yuno",
                errorText: _error,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitName,
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
