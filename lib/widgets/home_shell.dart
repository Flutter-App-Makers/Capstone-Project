// lib/widgets/home_shell.dart
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
              onTap: () {
                // NOTE: We capture context here before the async call.
// Flutter's analyzer may warn about using context across async gaps,
// but we guard access with `mounted`, so this is safe in practice.
                final scaffoldContext = context;
                final todos = ref.read(todoProvider);
                exportTodos(todos);
                if (mounted) {
                  Navigator.pop(scaffoldContext);
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(content: Text('Todos exported!')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Import Todos'),
              onTap: () {
                // NOTE: We capture context here before the async call.
// Flutter's analyzer may warn about using context across async gaps,
// but we guard access with `mounted`, so this is safe in practice.
                final scaffoldContext = context;
                () async {
                  final todos = await importTodos();
                  ref.read(todoProvider.notifier).setTodos(todos);
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(scaffoldContext);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      const SnackBar(content: Text('Todos imported!')),
                    );
                  }
                }();
              },
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
            icon: Icon(Icons.add),
            label: Text("Add Todo"),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "add_recurrent",
            onPressed: () {
              Navigator.pushNamed(context, '/addRecurrent');
            },
            icon: Icon(Icons.loop),
            label: Text("Add Recurrent"),
          ),
        ],
      ),
    );
  }
}
