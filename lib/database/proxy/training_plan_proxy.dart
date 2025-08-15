import 'dart:async';

import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:fittrackr/database/proxy/proxy.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:synchronized/synchronized.dart';

class TrainingPlanProxy implements ProxyPart<TrainingPlan, String> {
  final db = DatabaseHelper();
  final _lock = Lock();

  @override
  Future<ProxyResult<bool>> delete(TrainingPlan plan, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.trainingPlan.delete(plan);
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
        await db.trainingPlan.deleteAll();
        return ProxyResult(ProxyMethods.deleteAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.deleteAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insert(TrainingPlan plan, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.trainingPlan.insert(plan);
        return ProxyResult(ProxyMethods.insert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insert, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insertAll(List<TrainingPlan> plans, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.trainingPlan.insertAll(plans);
        return ProxyResult(ProxyMethods.insertAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insertAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<List<TrainingPlan>?>> selectAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        final result = await db.trainingPlan.selectAll();
        return ProxyResult(ProxyMethods.selectAll, result);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.selectAll, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> update(TrainingPlan plan, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.trainingPlan.update(plan);
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
        final exists = await db.trainingPlan.existsById(id);
        return ProxyResult(ProxyMethods.existsById, exists);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.existsById, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> upsert(TrainingPlan plan, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.trainingPlan.upsert(plan);
        return ProxyResult(ProxyMethods.upsert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.upsert, false, error: e);
      }
    });
  }
}
