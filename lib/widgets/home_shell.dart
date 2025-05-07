// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'dart:math';

import 'package:capstone_project/root_gate.dart';
import 'package:capstone_project/widgets/catchable_fish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/json_storage.dart';

class HomeShell extends ConsumerStatefulWidget {
  final Widget body;
  const HomeShell({super.key, required this.body});

  @override
  ConsumerState<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends ConsumerState<HomeShell> {
  final Map<String, GlobalKey<CatchableFishState>> fishKeys = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final isSyncing = ref.read(isSyncingProvider.notifier);
      isSyncing.state = true;
      await ref.read(todoProvider.notifier).syncFromFirebase();
      isSyncing.state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider).where((t) => !t.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Tacklebox"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueAccent),
              child: FutureBuilder<String?>(
                future: _getUsername(),
                builder: (context, snapshot) {
                  final name = snapshot.data ?? "Guest";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Welcome back,',
                          style:
                              TextStyle(fontSize: 18, color: Colors.white70)),
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Export Todos'),
              onTap: () => _exportTodos(context),
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Import Todos'),
              onTap: () => _confirmAndImportTodos(context),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('View Stats'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/stats');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_sync),
              title: const Text('Sync with Cloud'),
              onTap: () async {
                Navigator.pop(context); // Close drawer

                // Capture a clean dialog context via showDialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    // Immediately show loading spinner
                    Future.microtask(() async {
                      final isSyncing = ref.read(isSyncingProvider.notifier);
                      try {
                        isSyncing.state = true;
                        await ref
                            .read(todoProvider.notifier)
                            .syncFromFirebase();
                        if (mounted) {
                          Navigator.pop(dialogContext); // close loading
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Cloud sync complete!')),
                          );
                        }
                      } catch (e) {
                        print("🔥 Sync from cloud failed: $e");
                        if (mounted) {
                          Navigator.pop(dialogContext); // close loading
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cloud sync failed: $e')),
                          );
                        }
                      } finally {
                        isSyncing.state = false;
                      }
                    });
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.publish),
              title: const Text('Publish to Cloud'),
              onTap: () async {
                Navigator.pop(context); // Close drawer

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    Future.microtask(() async {
                      final isSyncing = ref.read(isSyncingProvider.notifier);
                      try {
                        isSyncing.state = true;
                        await ref
                            .read(todoProvider.notifier)
                            .publishToFirebase();
                        if (mounted) {
                          Navigator.pop(dialogContext); // Close loading spinner
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Published to cloud!')),
                          );
                        }
                      } catch (e) {
                        print("🔥 Publish to cloud failed: $e");
                        if (mounted) {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Publish failed: $e')),
                          );
                        }
                      } finally {
                        isSyncing.state = false;
                      }
                    });

                    return const Center(child: CircularProgressIndicator());
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () async {
                Navigator.pop(context); // close drawer
                await _signOut(context);
              },
            ),
          ],
        ),
      ),
      body: ref.watch(isSyncingProvider)
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Only spawn fish for active TODOs
                ...List.generate(todos.length, (i) {
                  final todo = todos[i];
                  final key = fishKeys.putIfAbsent(
                    todo.todoId,
                    () => GlobalKey<CatchableFishState>(),
                  );

                  final double spacing =
                      MediaQuery.of(context).size.height / (todos.length + 1);
                  return CatchableFish(
                    key: key,
                    center: Offset(
                      100 + Random().nextDouble() * 200,
                      spacing * (i + 1),
                    ),
                    radius: 30 + Random().nextDouble() * 20,
                    swimDuration: Duration(seconds: 3 + Random().nextInt(3)),
                    onCaught: () {
                      // optional: show sparkle or sound
                    },
                  );
                }),

                // Your real body
                widget.body,
              ],
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "add_todo",
            onPressed: () {
              Navigator.pushNamed(context, '/addTodo');
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Todo"),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "add_recurrent",
            onPressed: () {
              Navigator.pushNamed(context, '/addRecurrent');
            },
            icon: const Icon(Icons.loop),
            label: const Text("Add Recurrent"),
          ),
        ],
      ),
    );
  }

  Future<void> _exportTodos(BuildContext context) async {
    final scaffoldContext = context;

    final confirm = await _showConfirmExportDialog(context);
    if (confirm != true) {
      if (mounted) Navigator.pop(scaffoldContext);
      return;
    }

    final todos = ref.read(todoProvider);
    File? file = await exportTodos(todos);

    if (mounted) {
      Navigator.pop(scaffoldContext);
      if (file == null) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(content: Text('Failed to export todos')),
        );
        return;
      } else {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(content: Text('Todos exported to: ${file.path}')),
        );
      }
    }
  }

  Future<bool?> _showConfirmExportDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Export'),
        content: const Text(
            'Exporting will overwrite your existing task backup. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndImportTodos(BuildContext context) async {
    final scaffoldContext = context;

    final confirm = await _showConfirmDialog(context);
    if (confirm != true) {
      if (mounted) Navigator.pop(scaffoldContext);
      return;
    }

    _showLoadingDialog(context);

    final todos = await importTodos();
    if (todos != null) {
      await ref.read(todoProvider.notifier).setTodos(todos);
      if (mounted) {
        Navigator.pop(context); // Close loading spinner
        Navigator.pop(scaffoldContext); // Close drawer
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(content: Text('Todos imported!')),
        );
      }
    } else {
      if (mounted) {
        Navigator.pop(context); // Close loading spinner
        Navigator.pop(scaffoldContext); // Close drawer
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(content: Text('Import canceled.')),
        );
      }
    }
  }

  Future<bool?> _showConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Import'),
        content: const Text(
            'Importing will overwrite your current tasks. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out successfully!')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RootGate()),
        (_) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $e')),
      );
    }
  }

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

}
