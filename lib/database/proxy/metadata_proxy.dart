import 'dart:async';

import 'package:fittrackr/database/helper/helper.dart';
import 'package:fittrackr/database/proxy/proxy.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:synchronized/synchronized.dart';

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
