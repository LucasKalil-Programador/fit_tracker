import 'dart:convert';

import 'package:flutter/material.dart';

class MetadataState extends ChangeNotifier {
  final Map<String, String> _cache = Map();

  int get length => _cache.length;
  
  bool containsKey(String key) {
    return _cache.containsKey(key);
  }

  String? get(String key) {
    return _cache[key];
  }

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

  void put(String key, String value) async {
    _cache[key] = value;
    notifyListeners();
  }

  void putList(String key, List<String> list) {
    put(key, jsonEncode(list));
  }

  void putMap(String key, Map<String, Object?> map) {
    put(key, jsonEncode(map));
  }

  void remove(String key) async {
    _cache.remove(key);
    notifyListeners();
  }
}