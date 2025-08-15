import 'dart:async';
import 'dart:io';

import 'package:fittrackr/database/helper/exercise_helper.dart';
import 'package:fittrackr/database/helper/metadata_helper.dart';
import 'package:fittrackr/database/helper/report_helper.dart';
import 'package:fittrackr/database/helper/report_table_helper.dart';
import 'package:fittrackr/database/helper/training_history_helper.dart';
import 'package:fittrackr/database/helper/training_plan_helper.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
// ignore: unnecessary_import
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  final exercise          = ExerciseHelper();
  final trainingPlan      = TrainingPlanHelper();
  final metadata          = MetadataHelper();
  final reportTableHelper = ReportTableHelper();
  final reportHelper      = ReportHelper();
  final trainingHistory   = TrainingHistoryHelper();

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

  static const trainingHistorySQL = '''
          CREATE TABLE training_history(
            uuid TEXT PRIMARY KEY,
            training_name TEXT NOT NULL,
            exercises TEXT NOT NULL,
            date_time INTEGER NOT NULL
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
        await db.execute(trainingHistorySQL);
        await db.execute(metadataSQL);
        await db.execute(reportTableSQL);
        await db.execute(reportSQL);
      },
    );
  }
}

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
