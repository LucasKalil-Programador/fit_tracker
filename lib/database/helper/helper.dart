import 'dart:async';

import 'package:fittrackr/database/helper/database/database_multiplatform.dart';
import 'package:fittrackr/database/helper/exercise_helper.dart';
import 'package:fittrackr/database/helper/metadata_helper.dart';
import 'package:fittrackr/database/helper/report_helper.dart';
import 'package:fittrackr/database/helper/report_table_helper.dart';
import 'package:fittrackr/database/helper/sql.dart';
import 'package:fittrackr/database/helper/training_history_helper.dart';
import 'package:fittrackr/database/helper/training_plan_helper.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';
import 'package:synchronized/synchronized.dart';


class DatabaseHelper {
  final exercise          = ExerciseHelper();
  final trainingPlan      = TrainingPlanHelper();
  final metadata          = MetadataHelper();
  final reportTableHelper = ReportTableHelper();
  final reportHelper      = ReportHelper();
  final trainingHistory   = TrainingHistoryHelper();

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static String? password;

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
    return await openDatabase(
      version: 1,
      password: password,
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
