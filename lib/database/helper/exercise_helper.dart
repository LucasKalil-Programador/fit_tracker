import 'dart:async';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseHelper implements Helper<Exercise, String> {
  @override
  Future<void> insert(Exercise exercise) async {
    final db = await DatabaseHelper().database;
    await db.insert('exercise', {
      'uuid':   exercise.id,
      'name':   exercise.name,
      'amount': exercise.amount,
      'reps':   exercise.reps,
      'sets':   exercise.sets,
      'type':   exercise.type.name,
    });
  }

  @override
  Future<void> insertAll(List<Exercise> exercises) async {
    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var exercise in exercises) {
        batch.insert('exercise', {
          'uuid':   exercise.id,
          'name':   exercise.name,
          'amount': exercise.amount,
          'reps':   exercise.reps,
          'sets':   exercise.sets,
          'type':   exercise.type.name,
        });
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> upsert(Exercise exercise) async {
    final db = await DatabaseHelper().database;
    await db.insert('exercise', {
      'uuid':   exercise.id,
      'name':   exercise.name,
      'amount': exercise.amount,
      'reps':   exercise.reps,
      'sets':   exercise.sets,
      'type':   exercise.type.name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> update(Exercise exercise) async {
    final db = await DatabaseHelper().database;
    await db.update('exercise', {
      'name':   exercise.name,
      'amount': exercise.amount,
      'reps':   exercise.reps,
      'sets':   exercise.sets,
      'type':   exercise.type.name,
      },
      where: 'uuid = ?',
      whereArgs: [exercise.id],
    );
  }

  @override
  Future<void> delete(Exercise exercise) async {
    final db = await DatabaseHelper().database;
    await db.delete('exercise', where: 'uuid = ?', whereArgs: [exercise.id]);
  }

  @override
  Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('exercise');
  }

  @override
  Future<List<Exercise>> selectAll() async {
    final db = await DatabaseHelper().database;
    final data = await db.queryCursor('exercise');

    final List<Exercise> exercises = [];
    while(await data.moveNext()) {
      final element = data.current;
      final exercise = Exercise.fromMap(element);
      if(exercise != null) {
        exercises.add(exercise);
      }
    }

    return exercises;
  }
  
  @override
  Future<bool> existsById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'exercise',
      where: 'uuid = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
