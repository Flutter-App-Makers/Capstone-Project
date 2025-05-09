// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recurrent_task.dart';

final _firestore = FirebaseFirestore.instance;

CollectionReference<Map<String, dynamic>> get _userRecurrentTaskCollection {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    throw Exception("User not authenticated");
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('recurrent_tasks');
}

Future<void> uploadRecurrentTasks(List<RecurrentTask> tasks) async {
  final batch = _firestore.batch();

  for (final task in tasks) {
    final docRef = _userRecurrentTaskCollection.doc(task.id);
    batch.set(docRef, task.toJson());
  }

  await batch.commit();
}

Future<List<RecurrentTask>> downloadRecurrentTasks() async {
  print("⬇️ Downloading recurrent tasks...");
  final snapshot = await _userRecurrentTaskCollection.get();
  print("✅ Got ${snapshot.docs.length} recurrent tasks");
  return snapshot.docs
      .map((doc) => RecurrentTask.fromJson(doc.data()))
      .toList();
}
