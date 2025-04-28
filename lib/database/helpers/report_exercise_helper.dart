// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/base_entity.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/report.dart';
import 'package:fittrackr/database/entities/training_plan.dart';

mixin ReportExerciseHelper {
  Future<int> insertReport<T extends BaseEntity>(Report<T> report) async {
    final db = await (this as DatabaseHelper).database;
    if(T == Exercise || T == TrainingPlan) {
      final table = T == Exercise ? 'report_exercise' : 'report_training_plan';
      final column = T == Exercise ? 'exercise_id' : 'training_plan_id';
      report.id = await db.insert(table, {
        'data': report.data,
        'report_date': report.reportDate,
        column: report.object.id,
      });
      return report.id!;
    }
    return 0;
  }

  Future<int> deleteReport<T extends BaseEntity>(Report<T> report) async {
    final db = await (this as DatabaseHelper).database;
    if(T == Exercise || T == TrainingPlan) {
      final table = T == Exercise ? 'report_exercise' : 'report_training_plan';
      return db.delete(table, where: 'id = ?', whereArgs: [report.id]);
    }
    return 0;
  }

  Future<int> updateReport<T extends BaseEntity>(Report<T> report) async {
    final db = await (this as DatabaseHelper).database;
    if(T == Exercise || T == TrainingPlan) {
      final table = T == Exercise ? 'report_exercise' : 'report_training_plan';
      final column = T == Exercise ? 'exercise_id' : 'training_plan_id';
      return await db.update(table, 
      {
        'data': report.data,
        'report_date': report.reportDate,
        column: report.object.id,
      },
      where: 'id = ?',
      whereArgs: [report.id]
      );
    }
    return 0;
  }

  Future<List<Report<T>>> selectAllReport<T extends BaseEntity>() async {
    final db = await (this as DatabaseHelper).database;
    if(T == Exercise || T == TrainingPlan) {
      final query = T == Exercise ? '''
        SELECT r.id, r.data, r.report_date, r.exercise_id, e.name, e.amount, e.reps, e.sets, e.type FROM report_exercise r 
        INNER JOIN exercise e ON e.id = r.exercise_id
      ''' : '''
        SELECT r.id, r.data, r.report_date, r.training_plan_id, e.name FROM report_training_plan r 
        INNER JOIN training_plan e ON e.id = r.training_plan_id
      ''';
      final result = await db.rawQuery(query);
      return result.map(Report.fromMap<T>).toList();
    }
    return List.empty(growable: true);
  }

  Future<Report<T>?> selectReport<T extends BaseEntity>(int id) async {
    final db = await (this as DatabaseHelper).database;
    if(T == Exercise || T == TrainingPlan) {
      final query = T == Exercise ? '''
          SELECT r.id, r.data, r.report_date, r.exercise_id, e.name, e.amount, e.reps, e.sets, e.type FROM report_exercise r 
          INNER JOIN exercise e ON e.id = r.exercise_id
          WHERE r.id = ?
        ''' : '''
          SELECT r.id, r.data, r.report_date, r.training_plan_id, e.name FROM report_training_plan r 
          INNER JOIN training_plan e ON e.id = r.training_plan_id
          WHERE r.id = ?
        ''';
      final result = await db.rawQuery(query, [id]);
      return result.isNotEmpty ? Report.fromMap<T>(result.first) : null;
    }
    return null;
  }
}

/* 
- exercise                   Implementado
- training_plan              Implementado
- tag                        Implementado
- metadata                   Implementado
- report_exercise            Implementado Revisado
- report_training_plan       Implementado Revisado
- training_plan_has_exercise Implementado
- exercise_has_tag           Implementado
- training_plan_has_tag      Implementado

Insert
delete
update
selectAll
selectOne(id)
*/

