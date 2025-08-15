import 'dart:async';

import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:fittrackr/database/proxy/proxy.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:synchronized/synchronized.dart';

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
