// ignore_for_file: avoid_print

import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recurrent_task.dart';
import 'package:uuid/uuid.dart';
import '../utils/firebase_recurrent_sync.dart';

final recurrentTaskProvider =
    StateNotifierProvider<RecurrentTaskNotifier, List<RecurrentTask>>((ref) {
  return RecurrentTaskNotifier();
});

class RecurrentTaskNotifier extends StateNotifier<List<RecurrentTask>> {
  RecurrentTaskNotifier() : super([]);

  final _uuid = const Uuid();
  final Map<String, DateTime> _activeTasks = {};

  Future<void> addTask(String title) async {
    final newTask = RecurrentTask(
      id: _uuid.v4(),
      title: title,
    );
    state = [...state, newTask];
    await syncToFirebase();
  }

  void startTask(String taskId) {
    _activeTasks[taskId] = DateTime.now();
    state = [...state];
  }

  void stopTask(String taskId) async {
    final startTime = _activeTasks[taskId];
    if (startTime == null) return;

    final now = DateTime.now();
    final duration = now.difference(startTime);

    state = [
      for (final task in state)
        if (task.id == taskId)
          RecurrentTask(
            id: task.id,
            title: task.title,
            records: [
              ...task.records,
              TimeRecord(startTime: startTime, duration: duration)
            ],
          )
        else
          task
    ];

    _activeTasks.remove(taskId);

    await syncToFirebase();
  }

  Future<void> deleteTask(String taskId) async {
    state = state.where((t) => t.id != taskId).toList();
    await syncToFirebase();
  }

  Future<void> syncToFirebase() async {
    await uploadRecurrentTasks(state);
  }

  Future<void> syncFromFirebase() async {
    try {
      final downloaded = await downloadRecurrentTasks();
      state = downloaded;
    } catch (e, stack) {
      print("Recurrent sync failed: $e\n$stack");
    }
  }

  DateTime? getStartTime(String taskId) => _activeTasks[taskId];
  bool isTaskActive(String taskId) => _activeTasks.containsKey(taskId);
  UnmodifiableListView<RecurrentTask> get tasks => UnmodifiableListView(state);
}
