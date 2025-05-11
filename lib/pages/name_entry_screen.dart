import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

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

    // ✅ Update FirebaseAuth user display name
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload(); // Important to refresh the token
    }

    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => const MyApp()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: theme.colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "🌱 Welcome!",
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "What's your name?",
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "e.g. Yuno",
                          errorText: _error,
                          fillColor: theme.colorScheme
                              // ignore: deprecated_member_use
                              .surfaceVariant, // ✅ Compatible with Flutter 3.19.6
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _submitName,
                        icon: const Icon(Icons.check),
                        label: const Text("Continue"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
