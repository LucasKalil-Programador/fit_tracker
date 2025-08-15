import 'dart:async';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:fittrackr/database/proxy/proxy.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:synchronized/synchronized.dart';

class ExerciseProxy implements ProxyPart<Exercise, String> {
  final db = DatabaseHelper();
  final _lock = Lock();

  @override
  Future<ProxyResult<bool>> delete(Exercise exercise, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.delete(exercise);
        return ProxyResult(ProxyMethods.delete, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.delete, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> deleteAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.deleteAll();
        return ProxyResult(ProxyMethods.deleteAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.deleteAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insert(Exercise exercise, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.insert(exercise);
        return ProxyResult(ProxyMethods.insert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insert, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insertAll(List<Exercise> exercises, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.insertAll(exercises);
        return ProxyResult(ProxyMethods.insertAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insertAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<List<Exercise>?>> selectAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        final result = await db.exercise.selectAll();
        return ProxyResult(ProxyMethods.selectAll, result);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.selectAll, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> update(Exercise exercise, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.update(exercise);
        return ProxyResult(ProxyMethods.update, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.update, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool?>> existsById(String id, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        final exists = await db.exercise.existsById(id);
        return ProxyResult(ProxyMethods.existsById, exists);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.existsById, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> upsert(Exercise exercise, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.exercise.upsert(exercise);
        return ProxyResult(ProxyMethods.upsert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.upsert, false, error: e);
      }
    });
  }
}
