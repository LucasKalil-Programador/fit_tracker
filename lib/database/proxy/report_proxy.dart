import 'dart:async';

import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:fittrackr/database/proxy/proxy.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:synchronized/synchronized.dart';

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
