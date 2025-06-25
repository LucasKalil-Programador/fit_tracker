import 'dart:async';

import 'package:fittrackr/database/_database_helper.dart';
import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:synchronized/synchronized.dart';


// Proxy

class DatabaseProxy {
  DatabaseProxy._internal();

  static final DatabaseProxy _instance = DatabaseProxy._internal();
  static DatabaseProxy get instance => _instance;
  
  final sharedLock = Lock();

  final exercise         = ExerciseProxy();
  final trainingPlan     = TrainingPlanProxy();  
  final metadata         = MetadataProxy();
  late final reportTable = ReportTableProxy(sharedLock);
  late final report      = ReportProxy(sharedLock);
}


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

class MetadataProxy implements ProxyPart<MapEntry<String, String>, String> {
  final db = DatabaseHelper();
  final _lock = Lock();

  @override
  Future<ProxyResult<bool>> delete(MapEntry<String, String> entry, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.delete(entry);
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
        await db.metadata.deleteAll();
        return ProxyResult(ProxyMethods.deleteAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.deleteAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insert(MapEntry<String, String> entry, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.insert(entry);
        return ProxyResult(ProxyMethods.insert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insert, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insertAll(List<MapEntry<String, String>> entries, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.insertAll(entries);
        return ProxyResult(ProxyMethods.insertAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insertAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<List<MapEntry<String, String>>?>> selectAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        final result = await db.metadata.selectAll();
        return ProxyResult(ProxyMethods.selectAll, result);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.selectAll, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> update(MapEntry<String, String> entry, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.update(entry);
        return ProxyResult(ProxyMethods.update, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.update, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool?>> existsById(String key, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        final exists = await db.metadata.existsById(key);
        return ProxyResult(ProxyMethods.existsById, exists);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.existsById, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> upsert(MapEntry<String, String> entry, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.metadata.upsert(entry);
        return ProxyResult(ProxyMethods.upsert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.upsert, false, error: e);
      }
    });
  }
}

class ReportTableProxy implements ProxyPart<ReportTable, String> {
  final db = DatabaseHelper();
  final Lock _lock;

  ReportTableProxy(this._lock);

  @override
  Future<ProxyResult<bool>> delete(ReportTable table, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportTableHelper.delete(table);
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
        await db.reportTableHelper.deleteAll();
        return ProxyResult(ProxyMethods.deleteAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.deleteAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insert(ReportTable table, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportTableHelper.insert(table);
        return ProxyResult(ProxyMethods.insert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insert, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insertAll(List<ReportTable> tables, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportTableHelper.insertAll(tables);
        return ProxyResult(ProxyMethods.insertAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insertAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<List<ReportTable>?>> selectAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        final result = await db.reportTableHelper.selectAll();
        return ProxyResult(ProxyMethods.selectAll, result);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.selectAll, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> update(ReportTable table, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportTableHelper.update(table);
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
        final exists = await db.reportTableHelper.existsById(id);
        return ProxyResult(ProxyMethods.existsById, exists);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.existsById, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> upsert(ReportTable table, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportTableHelper.upsert(table);
        return ProxyResult(ProxyMethods.upsert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.upsert, false, error: e);
      }
    });
  }
}

class ReportProxy implements ProxyPart<Report, String> {
  final db = DatabaseHelper();
  final Lock _lock;

  ReportProxy(this._lock);

  @override
  Future<ProxyResult<bool>> delete(Report report, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportHelper.delete(report);
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
        await db.reportHelper.deleteAll();
        return ProxyResult(ProxyMethods.deleteAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.deleteAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insert(Report report, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportHelper.insert(report);
        return ProxyResult(ProxyMethods.insert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insert, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> insertAll(List<Report> reports, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportHelper.insertAll(reports);
        return ProxyResult(ProxyMethods.insertAll, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.insertAll, false, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<List<Report>?>> selectAll({bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        final result = await db.reportHelper.selectAll();
        return ProxyResult(ProxyMethods.selectAll, result);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.selectAll, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> update(Report report, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportHelper.update(report);
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
        final exists = await db.reportHelper.existsById(id);
        return ProxyResult(ProxyMethods.existsById, exists);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.existsById, null, error: e);
      }
    });
  }

  @override
  Future<ProxyResult<bool>> upsert(Report report, {bool printLog = true}) {
    return _lock.synchronized(() async {
      try {
        await db.reportHelper.upsert(report);
        return ProxyResult(ProxyMethods.upsert, true);
      } catch (e) {
        if (printLog) logger.e(e);
        return ProxyResult(ProxyMethods.upsert, false, error: e);
      }
    });
  }
}

enum ProxyMethods {insert, insertAll, upsert, delete, deleteAll, update, selectAll, existsById}

class ProxyResult<T> {
  final Object? error;
  final ProxyMethods method;
  final T result;

  ProxyResult(this.method, this.result, {this.error});

  bool get hasError => error != null;
  bool get notHasError => error == null;
}

abstract class ProxyPart<T, TID> {
  Future<ProxyResult<bool>> insert(T element, {bool printLog = true});
  Future<ProxyResult<bool>> insertAll(List<T> elements, {bool printLog = true});
  Future<ProxyResult<bool>> upsert(T element, {bool printLog = true});
  Future<ProxyResult<bool>> update(T element, {bool printLog = true});

  Future<ProxyResult<bool>> delete(T element, {bool printLog = true});
  Future<ProxyResult<bool>> deleteAll({bool printLog = true});

  Future<ProxyResult<bool?>> existsById(TID id, {bool printLog = true});

  Future<ProxyResult<List<T>?>> selectAll({bool printLog = true});
}