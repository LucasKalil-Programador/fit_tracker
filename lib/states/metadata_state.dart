import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/metadata.dart';
import 'package:flutter/material.dart';

class MetadataState extends ChangeNotifier {
  final Map<String, Metadata> _cache = Map();
  Map<String, Metadata> get map => Map.unmodifiable(_cache);

  Metadata? operator [](String key) => _cache[key];

  Metadata? get(String key) {
    return _cache[key];
  }

  Future<bool> set(Metadata metadata) async {
    int id = 0;
    if(metadata.id == null) {
      metadata.id = await DatabaseHelper().insertMetadata(metadata);
    } else {
      int result = await DatabaseHelper().updateMetadata(metadata);
      if(result > 0) id = metadata.id!;
    }
    
    if(id > 0) {
      _cache[metadata.key] = metadata;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> remove(Metadata metadata) async {
    int result = await DatabaseHelper().deleteMetadata(metadata);
    if(result > 0) {
      _cache.remove(metadata.key);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool contains(String key) {
    return _cache.containsKey(key);
  }

  Future<bool> loadDatabase() async {
    _cache.clear();
    final loaded = await DatabaseHelper().selectAllMetadata();
    for (var element in loaded) {
      _cache[element.key] = element;
    }
    notifyListeners();
    return _cache.isNotEmpty;
  }
}