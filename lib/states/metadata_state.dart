import 'dart:async';
import 'dart:convert';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/logger.dart';
import 'package:flutter/material.dart';

const themeKey = "Config:key";

class MetadataState extends ChangeNotifier {
  final ProxyPart<MapEntry<String, String>, String>? dbProxy;
  final Map<String, String> _cache = {};
  final _completer = Completer<bool>();

  MetadataState(this.dbProxy, {bool loadDatabase = false}) {
    _completer.complete(loadDatabase ? _loadFromDatabase() : true);
  }

  int get length => _cache.length;
  void forEach(void Function(String, String) action) => _cache.forEach(action);
  bool containsKey(String key) => _cache.containsKey(key);
  String? get(String key) => _cache[key];

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
    final entry = MapEntry(key, value);
    dbProxy?.upsert(entry).then(handleProxyResult);
    _cache[key] = value;
    notifyListeners();
  }

  void putList(String key, List<String> list) {
    put(key, jsonEncode(list));
  }

  void putMap(String key, Map<String, Object?> map) {
    put(key, jsonEncode(map));
  }

  void remove(String key) {
    dbProxy?.delete(MapEntry(key, _cache[key]!)).then(handleProxyResult);
    if(_cache.containsKey(key)) {
      _cache.remove(key);
      notifyListeners();
    }
  }

  Future<bool> waitLoaded() => _completer.future;

  Future<bool> _loadFromDatabase() async {
    if(dbProxy == null) return true;
    final entries = await dbProxy!.selectAll()
    .then((value) {
      handleProxyResult(value);
      return value;
    },);
    if(entries.result == null) return false;
    
    for (final entry in entries.result!) {
      _cache[entry.key] = entry.value;
    }
    
    notifyListeners();
    return true;
  }

  FutureOr<void> handleProxyResult(dynamic value) {
    logger.i("Metadata db result $value");
  }
}