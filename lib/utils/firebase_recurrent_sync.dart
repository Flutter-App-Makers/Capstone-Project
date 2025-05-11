// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recurrent_task.dart';

final _firestore = FirebaseFirestore.instance;

Future<CollectionReference<Map<String, dynamic>>>
    getUserRecurrentTaskCollection() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  if (username == null) throw Exception("No username in SharedPreferences");

  return _firestore
      .collection('users')
      .doc(username)
      .collection('recurrent_tasks');
}

Future<void> uploadRecurrentTasks(List<RecurrentTask> tasks) async {
  final batch = _firestore.batch();
  final collection = await getUserRecurrentTaskCollection();

  print("Uploading ${tasks.length} recurrent tasks to Firestore...");
  for (final task in tasks) {
    final docRef = collection.doc(task.id);
    print("Uploading task: ${task.title} (${task.id})");
    batch.set(docRef, task.toJson());
  }

  await batch.commit();
}

Future<List<RecurrentTask>> downloadRecurrentTasks() async {
  print("Downloading recurrent tasks...");
  final collection = await getUserRecurrentTaskCollection();
  final snapshot = await collection.get();
  print("Got ${snapshot.docs.length} recurrent tasks");
  return snapshot.docs
      .map((doc) => RecurrentTask.fromJson(doc.data()))
      .toList();
}
