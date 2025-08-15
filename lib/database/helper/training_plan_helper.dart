import 'dart:async';
import 'dart:convert';

import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:sqflite/sqflite.dart';

class TrainingPlanHelper implements Helper<TrainingPlan, String> {
  @override
  Future<void> insert(TrainingPlan plan) async {
    final db = await DatabaseHelper().database;
    await db.insert('training_plan', {
      'uuid': plan.id,
      'name': plan.name,
      'list': jsonEncode(plan.list),
    });
  }
  
  @override
  Future<void> insertAll(List<TrainingPlan> plans) async {
    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var plan in plans) {
        batch.insert('training_plan', {
          'uuid': plan.id,
          'name': plan.name,
          'list': jsonEncode(plan.list),
        });
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> upsert(TrainingPlan plan) async {
    final db = await DatabaseHelper().database;
    await db.insert('training_plan', {
      'uuid': plan.id,
      'name': plan.name,
      'list': jsonEncode(plan.list),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> update(TrainingPlan plan) async {
    final db = await DatabaseHelper().database;
    await db.update('training_plan', {
      'name': plan.name,
      'list': jsonEncode(plan.list),
      },
      where: 'uuid = ?',
      whereArgs: [plan.id],
    );
  }

  @override
  Future<void> delete(TrainingPlan plan) async {
    final db = await DatabaseHelper().database;
    await db.delete('training_plan', where: 'uuid = ?', whereArgs: [plan.id]);
  }

  @override
  Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('training_plan');
  }

  @override
  Future<List<TrainingPlan>> selectAll() async {
    final db = await DatabaseHelper().database;
    final data = await db.queryCursor('training_plan');

    final List<TrainingPlan> trainingPlans = [];
    while(await data.moveNext()) {
      final element = data.current;
      final plan = TrainingPlan.fromMap(element);
      if(plan != null) {
        trainingPlans.add(plan);
      }
    }

    return trainingPlans;
  }
  
  @override
  Future<bool> existsById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'training_plan',
      where: 'uuid = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
