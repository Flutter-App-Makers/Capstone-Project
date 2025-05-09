// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math';
import 'package:capstone_project/providers/recurrent_task_provider.dart';
import 'package:capstone_project/root_gate.dart';
import 'package:capstone_project/widgets/catchable_fish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/todo_provider.dart';
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

      try {
        await ref.read(todoProvider.notifier).syncFromFirebase();
        await ref.read(recurrentTaskProvider.notifier).syncFromFirebase();
      } catch (e) {
        print('🔥 Sync error: $e');
      } finally {
        isSyncing.state = false;
      }
    });

  }

  List<Widget> _buildDecorations() {
    final random = Random();
    final decorations = <Widget>[];

    for (int i = 0; i < 6; i++) {
      final isCloud = i % 2 == 0;
      final top =
          random.nextDouble() * MediaQuery.of(context).size.height * 0.7;
      final left =
          random.nextDouble() * MediaQuery.of(context).size.width * 0.8;

      decorations.add(Positioned(
        top: top,
        left: left,
        child: Opacity(
          opacity: 0.2 + random.nextDouble() * 0.3,
          child: Image.asset(
            isCloud ? 'assets/ghibli_cloud.png' : 'assets/totoro_forest.png',
            width: isCloud ? 120 : 90,
          ),
        ),
      ));
    }

    return decorations;
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider).where((t) => !t.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Tacklebox",
          style: GoogleFonts.notoSerif(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/totoro_forest.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: FutureBuilder<String?>(
                future: _getUsername(),
                builder: (context, snapshot) {
                  final name = snapshot.data ?? "Guest";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Welcome back,',
                          style: GoogleFonts.notoSerif(
                              fontSize: 18, color: Colors.white70)),
                      Text(name,
                          style: GoogleFonts.notoSerif(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
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
              onTap: () => _handleCloudSync(context),
            ),
            ListTile(
              leading: const Icon(Icons.publish),
              title: const Text('Publish to Cloud'),
              onTap: () => _handlePublish(context),
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
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFd0e6f6), // Sky blue
                    Color(0xFFF8EDD1), // Pale warm beige
                  ],
                ),
              ),
              child: Stack(
                children: [
                  ..._buildDecorations(), // 🎨 Ghibli cloud + Totoro forest decorations

                  // 🐟 Fish layer
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
                        // optional sparkle or sound
                      },
                    );
                  }),

                  // Main app content
                  widget.body,
                ],
              ),
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
        ],
      ),
    );
  }

  Future<void> _handleCloudSync(BuildContext context) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.microtask(() async {
          final isSyncing = ref.read(isSyncingProvider.notifier);
          try {
            isSyncing.state = true;
            await ref.read(todoProvider.notifier).syncFromFirebase();
            if (mounted) {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cloud sync complete!')),
              );
            }
          } catch (e) {
            if (mounted) {
              Navigator.pop(dialogContext);
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
  }

  Future<void> _handlePublish(BuildContext context) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.microtask(() async {
          final isSyncing = ref.read(isSyncingProvider.notifier);
          try {
            isSyncing.state = true;
            await ref.read(todoProvider.notifier).publishToFirebase();
            if (mounted) {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Published to cloud!')),
              );
            }
          } catch (e) {
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
  }

  Future<void> _exportTodos(BuildContext context) async {
    final scaffoldContext = context;
    final confirm = await _showConfirmExportDialog(context);
    if (confirm != true) {
      if (mounted) Navigator.pop(scaffoldContext);
      return;
    }

    final todos = ref.read(todoProvider);
    final file = await exportTodos(todos);
    if (mounted) {
      Navigator.pop(scaffoldContext);
      final message = file == null
          ? 'Failed to export todos'
          : 'Todos exported to: ${file.path}';
      ScaffoldMessenger.of(scaffoldContext)
          .showSnackBar(SnackBar(content: Text(message)));
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
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Export')),
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
    if (mounted) {
      Navigator.pop(context); // loading
      Navigator.pop(scaffoldContext); // drawer
      final msg = todos == null ? 'Import canceled.' : 'Todos imported!';
      if (todos != null) {
        await ref.read(todoProvider.notifier).setTodos(todos);
      }
      ScaffoldMessenger.of(scaffoldContext)
          .showSnackBar(SnackBar(content: Text(msg)));
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
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Import')),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signed out successfully!')));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootGate()),
          (_) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
      }
    }
  }

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}