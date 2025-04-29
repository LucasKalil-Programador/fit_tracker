import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/metadata.dart';
import 'package:flutter/material.dart';

class MetadataState extends ChangeNotifier {
  final Map<String, Metadata> _cache = Map();

  int get length => _cache.length;
  
  String? get(String key) {
    return _cache[key]?.value;
  }

  Future<bool> set(String key, String value) async {
    final metadata = Metadata(id: _cache[key]?.id, key: key, value: value);
    if(metadata.id == null) {
      await DatabaseHelper().insertMetadata(metadata);
    } else {
      await DatabaseHelper().updateMetadata(metadata);
    }
    if(metadata.id! <= 0) return false;
    
    _cache[metadata.key] = metadata;
    notifyListeners();
    return true;
  }

  bool containsKey(String key) {
    return _cache.containsKey(key);
  }

  Future<bool> remove(String key) async {
    if (containsKey(key)) {
      int result = await DatabaseHelper().deleteMetadata(_cache[key]!);
      if (result > 0) {
        _cache.remove(key);
        notifyListeners();
        return true;
      }
    }
    return false;
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