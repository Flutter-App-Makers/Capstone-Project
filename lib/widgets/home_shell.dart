// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../utils/json_storage.dart';

class HomeShell extends ConsumerStatefulWidget {
  final Widget body;
  const HomeShell({super.key, required this.body});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Todo App"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text('Menu',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
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
          ],
        ),
      ),
      body: widget.body,
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
    await exportTodos(todos);

    if (mounted) {
      Navigator.pop(scaffoldContext);
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(content: Text('Todos exported!')),
      );
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
    await ref.read(todoProvider.notifier).setTodos(todos);

    if (mounted) {
      Navigator.pop(context); // Close loading spinner
      Navigator.pop(scaffoldContext); // Close drawer
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(content: Text('Todos imported!')),
      );
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
}
