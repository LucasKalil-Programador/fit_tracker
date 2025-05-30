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
  
  late final ExerciseProxy     exercise = ExerciseProxy();
  late final TrainingPlanProxy trainingPlan = TrainingPlanProxy();  
  late final MetadataProxy     metadata = MetadataProxy();
}


class ExerciseProxy implements ProxyPart<Exercise> {
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
}

class TrainingPlanProxy implements ProxyPart<TrainingPlan> {
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
}

class MetadataProxy implements ProxyPart<MapEntry<String, String>> {
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
  Future<bool> insertAll(List<MapEntry<String, String>> entrys, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.insertAll(entrys);
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
}

abstract class ProxyPart<T> {
  Future<bool> insert(T element);
  Future<bool> insertAll(List<T> elements);
  Future<bool> delete(T element);
  Future<bool> update(T element);
  Future<List<T>?> selectAll();
}