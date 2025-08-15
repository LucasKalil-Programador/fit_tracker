import 'dart:async';
import 'dart:convert';

import 'package:fittrackr/database/entities/training_history.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:sqflite/sqflite.dart';

class TrainingHistoryHelper implements Helper<TrainingHistory, String> {
  @override
  Future<void> insert(TrainingHistory history) async {
    final db = await DatabaseHelper().database;
    await db.insert('training_history', {
      'uuid': history.id,
      'training_name': history.trainingName,
      'exercises': jsonEncode(history.exercises.map((e) => e.toMap()).toList()),
      'date_time': history.dateTime,
    });
  }

  @override
  Future<void> insertAll(List<TrainingHistory> histories) async {
    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var history in histories) {
        batch.insert('training_history', {
          'uuid': history.id,
          'training_name': history.trainingName,
          'exercises': jsonEncode(history.exercises.map((e) => e.toMap()).toList()),
          'date_time': history.dateTime,
        });
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> upsert(TrainingHistory history) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      'training_history',
      {
        'uuid': history.id,
        'training_name': history.trainingName,
        'exercises': jsonEncode(history.exercises.map((e) => e.toMap()).toList()),
        'date_time': history.dateTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(TrainingHistory history) async {
    final db = await DatabaseHelper().database;
    await db.update(
      'training_history',
      {
        'training_name': history.trainingName,
        'exercises': jsonEncode(history.exercises.map((e) => e.toMap()).toList()),
        'date_time': history.dateTime,
      },
      where: 'uuid = ?',
      whereArgs: [history.id],
    );
  }

  @override
  Future<void> delete(TrainingHistory history) async {
    final db = await DatabaseHelper().database;
    await db.delete('training_history', where: 'uuid = ?', whereArgs: [history.id]);
  }

  @override
  Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('training_history');
  }

  @override
  Future<List<TrainingHistory>> selectAll() async {
    final db = await DatabaseHelper().database;
    final data = await db.query('training_history');

    return data.map((element) {
      final id = element['uuid'] as String?;
      final trainingName = element['training_name'] as String;
      final exercisesStr = element['exercises'] as String;
      final dateTimeInt = element['date_time'] as int;

      final exercises = (jsonDecode(exercisesStr) as List)
          .map((x) => ExerciseSnapshot.fromMap(Map<String, Object?>.from(x)))
          .toList();

      return TrainingHistory(
        id: id,
        trainingName: trainingName,
        exercises: exercises,
        dateTime: dateTimeInt,
      );
    }).toList();
  }

  @override
  Future<bool> existsById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'training_history',
      where: 'uuid = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
