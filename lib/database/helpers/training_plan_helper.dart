/* // import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

mixin TrainingPlanHelper {
  Future<int> insertTrainingPlan(TrainingPlan plan) async {
    final db = await (this as DatabaseHelper).database;
    plan.id = await db.insert('training_plan', {
      'name': plan.name,
    });
    return plan.id!;
  }

  Future<int> deleteTrainingPlan(TrainingPlan plan) async {
    final db = await (this as DatabaseHelper).database;
    return db.delete('training_plan', where: 'id = ?', whereArgs: [plan.id]);
  }

  Future<int> updateTrainingPlan(TrainingPlan plan) async {
    final db = await (this as DatabaseHelper).database;
    return await db.update(
      'training_plan',
      {'name': plan.name},
      where: 'id = ?',
      whereArgs: [plan.id],
    );
  }

  Future<List<TrainingPlan>> selectAllTrainingPlan() async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('training_plan');
    return result.map(TrainingPlan.fromMap).toList();
  }

  Future<TrainingPlan?> selectTrainingPlan(int id) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('training_plan', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? TrainingPlan.fromMap(result.first) : null;
  }

/* CREATE TABLE training_plan_has_exercise (
    training_plan_id INTEGER NOT NULL,
    exercise_id INTEGER NOT NULL,
    position INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (training_plan_id, exercise_id),
    FOREIGN KEY (training_plan_id) REFERENCES training_plan(id) ON DELETE CASCADE,
    FOREIGN KEY (exercise_id) REFERENCES exercise(id) ON DELETE CASCADE
); */
  Future<void> setPlanExerciseList(TrainingPlan plan, List<Exercise> exercises) async {
    final db = await (this as DatabaseHelper).database;
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      var whereArgs = [plan.id];
      whereArgs.addAll(exercises.map((e) => e.id));
      batch.delete(
        'training_plan_has_exercise',
        where:
            'training_plan_id = ? AND exercise_id NOT IN (${List.filled(exercises.length, '?').join(', ')})',
        whereArgs: whereArgs,
      );
      for (int i = 0; i < exercises.length; i++) {
        batch.insert(
          'training_plan_has_exercise',
          {
            'training_plan_id': plan.id,
            'exercise_id': exercises[i].id,
            'position': i,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return await batch.commit(noResult: true);
    });
  }

  Future<List<Exercise>> getPlanExerciseList(TrainingPlan plan) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.rawQuery(
      '''SELECT position, e.id, e.name, e.amount, e.reps, e.sets, e.type FROM training_plan_has_exercise 
         INNER JOIN exercise e ON exercise_id = e.id 
         WHERE training_plan_id = ?''',
      [plan.id]
    );
    var resultList = result.toList();
    resultList.sort((e1, e2) => (e1['position'] as int).compareTo(e2['position'] as int));

    return resultList.map(Exercise.fromMap).toList();
  }
}
 */