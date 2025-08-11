import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/utils/logger.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: unnecessary_import
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';

// DB Helper

class DatabaseHelper {
  final exercise          = ExerciseHelper();
  final trainingPlan      = TrainingPlanHelper();
  final metadata          = MetadataHelper();
  final reportTableHelper = ReportTableHelper();
  final reportHelper      = ReportHelper();

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
  
  static const reportTableSQL = '''
          CREATE TABLE report_table(
            uuid TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            value_suffix TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL
          );
        ''';
  
  static const reportSQL = '''
          CREATE TABLE report(
            uuid TEXT PRIMARY KEY,
            note TEXT NOT NULL,
            report_date INTEGER NOT NULL,
            value REAL NOT NULL,
            report_table_uuid TEXT NOT NULL
          );
        ''';

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  static final _initLocker = Lock();
  Future<Database> get database async {
    return _initLocker.synchronized(() async {
      if (_database != null) return _database!;
      _database = await _initDb();
      return _database!;
    });
  }

  Future<Database> _initDb() async {
    logger.i("starting Database");
    late final String path;
    if(kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      path = 'fittracker.db';
    } else if(Platform.isAndroid) {
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
        await db.execute(reportTableSQL);
        await db.execute(reportSQL);
      },
    );
  }
}


// Exercise

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


// TrainingPlan

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


// Metadata

class MetadataHelper implements Helper<MapEntry<String, String>, String> {
  @override
  Future<void> insert(MapEntry<String, String> metadata) async {
    final db = await DatabaseHelper().database;
    await db.insert('metadata', {
      'key': metadata.key,
      'value': metadata.value,
    });
  }

  @override
  Future<void> insertAll(List<MapEntry<String, String>> metadataList) async {
    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var metadata in metadataList) {
        batch.insert('metadata', {
          'key': metadata.key,
          'value': metadata.value,
        });
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> upsert(MapEntry<String, String> metadata) async {
    final db = await DatabaseHelper().database;
    await db.insert('metadata', {
      'key': metadata.key,
      'value': metadata.value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
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
  Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('metadata');
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
  
  @override
  Future<bool> existsById(String key) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'metadata',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}


// ReportTable

class ReportTableHelper implements Helper<ReportTable, String> {
  @override
  Future<void> insert(ReportTable table) async {
    final db = await DatabaseHelper().database;
    await db.insert('report_table', {
      'uuid': table.id,
      'name': table.name,
      'description': table.description,
      'value_suffix': table.valueSuffix,
      'created_at': table.createdAt,
      'updated_at': table.updatedAt
    });
  }

  @override
  Future<void> insertAll(List<ReportTable> tables) async {
    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var table in tables) {
        batch.insert('report_table', {
          'uuid': table.id,
          'name': table.name,
          'description': table.description,
          'value_suffix': table.valueSuffix,
          'created_at': table.createdAt,
          'updated_at': table.updatedAt
        });
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> upsert(ReportTable table) async {
    final db = await DatabaseHelper().database;
    await db.insert('report_table', {
      'uuid': table.id,
      'name': table.name,
      'description': table.description,
      'value_suffix': table.valueSuffix,
      'created_at': table.createdAt,
      'updated_at': table.updatedAt
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> update(ReportTable table) async {
    final db = await DatabaseHelper().database;
    await db.update('report_table', {
      'name': table.name,
      'description': table.description,
      'value_suffix': table.valueSuffix,
      'created_at': table.createdAt,
      'updated_at': table.updatedAt
    },
    where: 'uuid = ?',
    whereArgs: [table.id],
    );
  }

  @override
  Future<void> delete(ReportTable table) async {
    final db = await DatabaseHelper().database;
    await db.delete('report_table', where: 'uuid = ?', whereArgs: [table.id]);
  }

  @override
  Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('report_table');
  }

  @override
  Future<List<ReportTable>> selectAll() async {
    final db = await DatabaseHelper().database;
    final data = await db.queryCursor('report_table');

    final List<ReportTable> tables = [];
    while(await data.moveNext()) {
      final element = data.current;
      final table = ReportTable.fromMap(element);
      if(table != null) {
        tables.add(table);
      }
    }

    return tables;
  }

  @override
  Future<bool> existsById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'report_table',
      where: 'uuid = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}


// Report

class ReportHelper implements Helper<Report, String> {
  @override
  Future<void> insert(Report report) async {
    final db = await DatabaseHelper().database;
    await db.insert('report', {
      'uuid': report.id,
      'note': report.note,
      'report_date': report.reportDate,
      'value': report.value,
      'report_table_uuid': report.tableId,
    });
  }

  @override
  Future<void> insertAll(List<Report> reports) async {
    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var report in reports) {
        batch.insert('report', {
          'uuid': report.id,
          'note': report.note,
          'report_date': report.reportDate,
          'value': report.value,
          'report_table_uuid': report.tableId,
        });
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> upsert(Report report) async {
    final db = await DatabaseHelper().database;
    await db.insert('report', {
      'uuid': report.id,
      'note': report.note,
      'report_date': report.reportDate,
      'value': report.value,
      'report_table_uuid': report.tableId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> update(Report report) async {
    final db = await DatabaseHelper().database;
    await db.update('report', {
      'uuid': report.id,
      'note': report.note,
      'report_date': report.reportDate,
      'value': report.value,
      'report_table_uuid': report.tableId,
    },
    where: 'uuid = ?',
    whereArgs: [report.id],
    );
  }

  @override
  Future<void> delete(Report report) async {
    final db = await DatabaseHelper().database;
    await db.delete('report', where: 'uuid = ?', whereArgs: [report.id]);
  }

  @override
  Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('report');
  }

  @override
  Future<List<Report>> selectAll() async {
    final db = await DatabaseHelper().database;
    final data = await db.queryCursor('report');

    final List<Report> tables = [];
    while(await data.moveNext()) {
      final element = data.current;
      final table = Report.fromMap(element);
      if(table != null) {
        tables.add(table);
      }
    }

    return tables;
  }

  @override
  Future<bool> existsById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'report',
      where: 'uuid = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}

// Helper interface

abstract class Helper<T, TID> {
  Future<void> insert(T element);
  Future<void> insertAll(List<T> element);
  Future<void> upsert(T element);
  Future<void> update(T element);

  Future<bool> existsById(TID element);
  // Future<int> count();
  
  Future<void> delete(T element);
  Future<void> deleteAll();
  
  Future<List<T>> selectAll();
}
