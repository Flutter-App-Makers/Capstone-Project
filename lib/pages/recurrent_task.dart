import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recurrent_task_provider.dart';
import 'recurrent_task_stats.dart';
import 'package:intl/intl.dart';

class RecurrentTasksPage extends ConsumerWidget {
  const RecurrentTasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(recurrentTaskProvider);
    final notifier = ref.read(recurrentTaskProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Recurrent Tasks')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final isActive = notifier.isTaskActive(task.id);

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Dismissible(
              key: ValueKey(task.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) async {
                return await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete Task"),
                    content: Text(
                        'Are you sure you want to delete "${task.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (_) => notifier.deleteTask(task.id),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: isActive
                      ? Text(
                          'Started at ${DateFormat.Hm().format(notifier.getStartTime(task.id)!)}',
                          style: const TextStyle(color: Colors.green),
                        )
                      : null,
                  trailing: ElevatedButton.icon(
                    icon: Icon(isActive ? Icons.stop : Icons.play_arrow),
                    label: Text(isActive ? 'Stop' : 'Start'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      minimumSize: const Size(96, 36),
                    ),
                    onPressed: () {
                      if (isActive) {
                        notifier.stopTask(task.id);
                      } else {
                        notifier.startTask(task.id);
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecurrentTaskStatsPage(task: task),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = TextEditingController();
          final result = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('New Recurrent Task'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Task title'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, controller.text),
                  child: const Text('Add'),
                ),
              ],
            ),
          );

          if (result != null && result.trim().isNotEmpty) {
            notifier.addTask(result.trim());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
