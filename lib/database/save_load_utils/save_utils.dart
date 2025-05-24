
import 'dart:async';
import 'dart:convert';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/base_list_state.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:synchronized/synchronized.dart';

class DebounceRunner {
  Duration delay;
  Future<void> Function() callback;

  Timer? _debouncer;
  final _lock = Lock();

  DebounceRunner({required this.delay, required this.callback});

  void runAfter() {
    _debouncer?.cancel();
    _debouncer = Timer(delay, run);
  }

  Future<void> run() async {
    late DateTime start;
    await _lock.synchronized(() async {
      if(kDebugMode) start = DateTime.now();
      
      await callback();

      if(kDebugMode) {
        final elapsed = DateTime.now().difference(start);
        print("Save took: $elapsed");
      }
    });
  }
}

/* CREATE TABLE metadata(
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
); 
*/
Future<void> saveMetadata(Map<String, String> data) async {
  final db = await DatabaseHelper().database;
  final batch = db.batch();
  for (var element in data.entries) {
    batch.insert('metadata', {
      'key': element.key,
      'value': element.value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  batch.delete(
    'metadata',
    where: 'key NOT IN (${List.filled(data.keys.length, '?').join(', ')})',
    whereArgs: data.keys.toList(),
  );

  batch.commit();
  if(kDebugMode) {
    print("------ Database call Metadata------");
    for (var element in data.entries) {
      print("${element.key}: ${element.value}");
    }
  }
}

/* CREATE TABLE exercise(
  uuid TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  amount INTEGER NOT NULL,
  reps INTEGER NOT NULL,
  sets INTEGER NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('cardio', 'musclework'))
);
*/
Future<void> saveExercise(Map<UpdateEvent, List<Exercise>> data) async {
  final db = await DatabaseHelper().database;
  final batch = db.batch();
  final insertOrUpdateList = [...(data[UpdateEvent.insert] ?? []), ...(data[UpdateEvent.update] ?? [])];

  for (var element in insertOrUpdateList) {
    batch.insert('exercise', {
      'uuid': element.id,
      'name': element.name,
      'amount': element.amount,
      'reps': element.reps,
      'sets': element.sets,
      // ignore: unnecessary_cast
      'type': (element.type as ExerciseType).name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  for (var element in data[UpdateEvent.remove] ?? []) {
     batch.delete('exercise', where: 'uuid = ?', whereArgs: [element.id]);
  }

  await batch.commit();
  if(kDebugMode) {
    print("------ Database call Exercise ------");
    printDebug(data);
  }
}

/* CREATE TABLE training_plan(
  uuid TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  list TEXT NOT NULL
); 
*/
Future<void> saveTrainingPlan(Map<UpdateEvent, List<TrainingPlan>> data, [bool debug = false]) async {
  final db = await DatabaseHelper().database;
  final batch = db.batch();
  final insertOrUpdateList = [...(data[UpdateEvent.insert] ?? []), ...(data[UpdateEvent.update] ?? [])];
  for (var element in insertOrUpdateList) {
    batch.insert('training_plan', {
      'uuid': element.id,
      'name': element.name,
      'list': jsonEncode(element.list),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  for (var element in data[UpdateEvent.remove] ?? []) {
    batch.delete('training_plan', where: 'uuid = ?', whereArgs: [element.id]);
  }

  await batch.commit();
  if(kDebugMode) {
    print("------ Database call TrainingPlan ------");
    printDebug(data);
  }
}

void printDebug(Map<UpdateEvent, List> data) {
  if (kDebugMode) {
    print("${UpdateEvent.insert}: ${data[UpdateEvent.insert]!.length}");
    print("${UpdateEvent.update}: ${data[UpdateEvent.update]!.length}");
    print("${UpdateEvent.remove}: ${data[UpdateEvent.remove]!.length}");
  }
}
