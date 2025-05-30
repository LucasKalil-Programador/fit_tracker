import 'dart:async';

import 'package:fittrackr/database/_database_helper.dart';
import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/logger.dart';
import 'package:synchronized/synchronized.dart';


// Proxy

class DatabaseProxy {
  DatabaseProxy._internal();

  static final DatabaseProxy _instance = DatabaseProxy._internal();
  static DatabaseProxy get instance => _instance;
  
  final ExerciseProxy     exercise     = ExerciseProxy();
  final TrainingPlanProxy trainingPlan = TrainingPlanProxy();  
  final MetadataProxy     metadata     = MetadataProxy();
  final ReportTableProxy  reportTable  = ReportTableProxy();
}


class ExerciseProxy implements ProxyPart<Exercise, String> {
  final _lock = Lock();
  final db = DatabaseHelper();

  @override
  Future<bool> delete(Exercise exercise, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.delete(exercise);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<bool> insert(Exercise exercise, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.insert(exercise);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }

  @override
  Future<bool> insertAll(List<Exercise> exercises, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.insertAll(exercises);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<List<Exercise>?> selectAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        return await db.exercise.selectAll();
      } catch (e) {
        if(printLog) logger.e(e);
        return null;
      }
    });
  }
  
  @override
  Future<bool> update(Exercise exercise, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.update(exercise);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<bool?> existsById(String id, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        return await db.exercise.existsById(id);
      } catch (e) {
        if(printLog) logger.e(e);
        return null;
      }
    });
  }
}

class TrainingPlanProxy implements ProxyPart<TrainingPlan, String> {
  final _lock = Lock();
  final db = DatabaseHelper();

  @override
  Future<bool> delete(TrainingPlan plan, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.trainingPlan.delete(plan);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<bool> insert(TrainingPlan plan, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.trainingPlan.insert(plan);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<bool> insertAll(List<TrainingPlan> plans, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.trainingPlan.insertAll(plans);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<List<TrainingPlan>?> selectAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        return await db.trainingPlan.selectAll();
      } catch (e) {
        if(printLog) logger.e(e);
        return null;
      }
    });
  }
  
  @override
  Future<bool> update(TrainingPlan plan, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.trainingPlan.update(plan);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<bool?> existsById(String id, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        return await db.trainingPlan.existsById(id);
      } catch (e) {
        if(printLog) logger.e(e);
        return null;
      }
    });
  }
}

class MetadataProxy implements ProxyPart<MapEntry<String, String>, String> {
  final _lock = Lock();
  final db = DatabaseHelper();

  @override
  Future<bool> delete(MapEntry<String, String> entry, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.delete(entry);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<bool> insert(MapEntry<String, String> entry, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.insert(entry);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }

  @override
  Future<bool> insertAll(List<MapEntry<String, String>> entries, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.insertAll(entries);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<List<MapEntry<String, String>>?> selectAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        return await db.metadata.selectAll();
      } catch (e) {
        if(printLog) logger.e(e);
        return null;
      }
    });
  }
  
  @override
  Future<bool> update(MapEntry<String, String> entry, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.update(entry);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }
  
  @override
  Future<bool?> existsById(String key, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        return await db.metadata.existsById(key);
      } catch (e) {
        if(printLog) logger.e(e);
        return null;
      }
    });
  }
}

class ReportTableProxy implements ProxyPart<ReportTable, String> {
  final _lock = Lock();
  final db = DatabaseHelper();

  @override
  Future<bool> delete(ReportTable table, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportTableHelper.delete(table);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }

  @override
  Future<bool> insert(ReportTable table, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportTableHelper.insert(table);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }

  @override
  Future<bool> insertAll(List<ReportTable> tables, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportTableHelper.insertAll(tables);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }

  @override
  Future<List<ReportTable>?> selectAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        return await db.reportTableHelper.selectAll();
      } catch (e) {
        if(printLog) logger.e(e);
        return null;
      }
    });
  }

  @override
  Future<bool> update(ReportTable table, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportTableHelper.update(table);
        return true;
      } catch (e) {
        if(printLog) logger.e(e);
        return false;
      }
    });
  }

  @override
  Future<bool?> existsById(String id, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        return await db.reportTableHelper.existsById(id);
      } catch (e) {
        if(printLog) logger.e(e);
        return null;
      }
    });
  }
}

abstract class ProxyPart<T, TID> {
  Future<bool> insert(T element);
  Future<bool> insertAll(List<T> elements);
  Future<bool> delete(T element);
  Future<bool> update(T element);
  Future<List<T>?> selectAll();
  Future<bool?> existsById(TID id);
}