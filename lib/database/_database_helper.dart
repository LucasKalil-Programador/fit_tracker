import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fittrackr/database/entities.dart';

// ignore: unnecessary_import
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:path/path.dart';


// DB Helper

class DatabaseHelper {
  ExerciseHelper exercise = ExerciseHelper();
  TrainingPlanHelper trainingPlan = TrainingPlanHelper();
  MetadataHelper metadata = MetadataHelper();

  static const exerciseSQL = '''
          CREATE TABLE exercise(
            uuid TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            amount INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            sets INTEGER NOT NULL,
            type TEXT NOT NULL CHECK(type IN ('cardio', 'musclework'))
          );
        ''';

  static const trainingPlanSQL = '''
          CREATE TABLE training_plan(
            uuid TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            list TEXT NOT NULL
          );
        ''';

  static const metadataSQL = '''
          CREATE TABLE metadata(
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          );
        ''';

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    late final String path;
    if(Platform.isAndroid) {
      path = join(await getDatabasesPath(), 'fittracker.db');
    } else if(Platform.isWindows) {
      path = ":memory:";
      databaseFactory = databaseFactoryFfi;
    }

    return await openDatabase(
      path, 
      version: 1,
      onCreate: (db, version) async {
        await db.execute(exerciseSQL);
        await db.execute(trainingPlanSQL);
        await db.execute(metadataSQL);
      },
    );
  }
}


// Exercise

class ExerciseHelper implements Helper<Exercise> {
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
}


// TrainingPlan

class TrainingPlanHelper implements Helper<TrainingPlan> {
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
}


// Metadata

class MetadataHelper implements Helper<MapEntry<String, String>> {
  @override
  Future<void> insert(MapEntry<String, String> metadata) async {
    final db = await DatabaseHelper().database;
    await db.insert('metadata', {
      'key': metadata.key,
      'value': metadata.value,
    });
  }

  @override
  Future<void> update(MapEntry<String, String> metadata) async {
    final db = await DatabaseHelper().database;
    await db.update('metadata', {
      'value': metadata.value,
      },
      where: 'key = ?',
      whereArgs: [metadata.key],
    );
  }

  @override
  Future<void> delete(MapEntry<String, String> metadata) async {
    final db = await DatabaseHelper().database;
    await db.delete('metadata', where: 'key = ?', whereArgs: [metadata.key]);
  }

  @override
  Future<List<MapEntry<String, String>>> selectAll() async {
    final db = await DatabaseHelper().database;
    final data = await db.queryCursor('metadata');

    final List<MapEntry<String, String>> metadata = [];
    while (await data.moveNext()) {
      final element = data.current;
      final key = element["key"];
      final value = element["value"];
      if(key is String && value is String) {
        metadata.add(MapEntry(key, value));
      }
    }
    
    return metadata;
  }
}

// Helper interface

abstract class Helper<T> {
  Future<void> insert(T element);
  Future<void> update(T element);
  Future<void> delete(T element);
  Future<List<T>> selectAll();
}
