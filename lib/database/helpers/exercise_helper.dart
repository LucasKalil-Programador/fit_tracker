// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/exercise.dart';

mixin ExerciseHelper {
  Future<int> insertExercise(Exercise exercise) async {
    final db = await (this as DatabaseHelper).database;
    exercise.id = await db.insert('exercise', {
      'name': exercise.name,
      'amount': exercise.amount,
      'reps': exercise.reps,
      'sets': exercise.sets,
      'type': exercise.type.name,
    });
    return exercise.id!;
  }

  Future<void> insertAllExercise(List<Exercise> exercises) async {
    final db = await (this as DatabaseHelper).database;
    await db.transaction((txn) async {
      for (var exercise in exercises) {
        exercise.id = await txn.insert('exercise', {
          'name': exercise.name,
          'amount': exercise.amount,
          'reps': exercise.reps,
          'sets': exercise.sets,
          'type': exercise.type.name,
        });
      }
    });
  }

  Future<int> deleteExercise(Exercise exercise) async {
    final db = await (this as DatabaseHelper).database;
    return await db.delete('exercise', where: 'id = ?', whereArgs: [exercise.id]);
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await (this as DatabaseHelper).database;
    return db.update(
      'exercise',
      {
        'name': exercise.name,
        'amount': exercise.amount,
        'reps': exercise.reps,
        'sets': exercise.sets,
        'type': exercise.type.name,
      },
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<List<Exercise>> selectAllExercise() async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('exercise', orderBy: 'name ASC');
    return result.map(Exercise.fromMap).toList();
  }

  Future<Exercise?> selectExercise(int id) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('exercise', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Exercise.fromMap(result.first) : null;
  }
}
