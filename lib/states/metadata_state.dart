import 'dart:async';
import 'dart:convert';

import 'package:fittrackr/database/proxy/proxy.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:flutter/material.dart';

const themeKey = "Theme:key";
const localeKey = "Locale:key";
const metadataActivatedKey = "workout:activated";
const metadataDoneKey = "workout:donelist";
const lastUpdateKey = "Manager:LastUpdate";
const lastTimeStampKey = "Manager:LastTimeStamp";

class MetadataState extends ChangeNotifier {
  final ProxyPart<MapEntry<String, String>, String>? dbProxy;
  final Map<String, String> _cache = {};
  final _completer = Completer<bool>();

  MetadataState({this.dbProxy, bool loadDatabase = false}) {
    _completer.complete(loadDatabase ? _loadFromDatabase() : true);
  }

  int get length => _cache.length;
  void forEach(void Function(String, String) action) => _cache.forEach(action);
  bool containsKey(String key) => _cache.containsKey(key);
  String? get(String key) => _cache[key];

  Map<String, String> get clone => Map.from(_cache);

  final String serializationKey = "metadata";

  List<String>? getList(String key) {
    final value = _cache[key];
    if(value == null) return null;
    return (jsonDecode(value) as List).cast<String>();
  }

  Map<String, Object?>? getMap(String key) {
    final value = _cache[key];
    if(value == null) return null;
    return (jsonDecode(value) as Map).cast<String, Object?>();
  }

  void put(String key, String value) {
    String? oldValue = _cache[key];
    final entry = MapEntry(key, value);

    _cache[key] = value;
    notifyListeners();

    dbProxy?.upsert(entry)
      .then((value) {
        if (value.hasError) _rollback(key, oldValue);
      });
  }

  void putList(String key, List<String> list) {
    put(key, jsonEncode(list));
  }

  void putMap(String key, Map<String, Object?> map) {
    put(key, jsonEncode(map));
  }

  void remove(String key) {
    if (!_cache.containsKey(key)) return;

    String? oldValue = _cache[key];
    final entry = MapEntry(key, oldValue!);

    _cache.remove(key);
    notifyListeners();

    dbProxy?.delete(entry)
      .then((value) {
        if (value.hasError) _rollback(key, oldValue);
      });
  }

  Future<bool> waitLoad() => _completer.future;

  Future<bool> _loadFromDatabase() async {
    if(dbProxy == null) return true;
    final entries = await dbProxy!.selectAll();
    if(entries.result == null) return false;
    
    for (final entry in entries.result!) {
      _cache[entry.key] = entry.value;
    }
    
    notifyListeners();
    return true;
  }

  void _rollback(String key, String? oldValue) {
    if(oldValue != null) {
      _cache[key] = oldValue;
      logger.i('Rollback: restored "$key" to previous value.');
    } else {
      _cache.remove(key);
      logger.i('Rollback: removed "$key" after failed operation.');
    }
    if (oldValue != _cache[key]) {
      notifyListeners();
    }
  }
}