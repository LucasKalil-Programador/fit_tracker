import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum UpdateEvent { insert, update, remove }

abstract class BaseListState<T extends BaseEntity> extends ChangeNotifier {
  final ProxyPart<T, dynamic>? dbProxy;
  final List<T> _cache = [];

  List<T> get clone => List<T>.from(_cache);
  bool get isEmpty => _cache.isEmpty;
  bool get isNotEmpty => _cache.isNotEmpty;
  int get length => _cache.length;

  T? get firstOrNull => _cache.isNotEmpty ? _cache.first : null;
  T? get lastOrNull => _cache.isNotEmpty ? _cache.last : null;

  BaseListState(this.dbProxy, {bool loadDatabase = false}) {
    if(loadDatabase) _loadFromDatabase();
  }

  T operator [](int index) => _cache[index];

  void operator []=(int index, T value) {
    _cache[index] = value;
    dbProxy?.update(value);
    this.sort(notify: true);
  }

  T get(int index) {
    return _cache[index];
  }

  bool add(T entity) {
    if(containsId(entity)) {
      return false;
    }
    entity.id ??= Uuid().v4();

    _cache.add(entity);

    dbProxy?.insert(entity);
    this.sort(notify: true);
    return true;
  }

  bool addAll(List<T> entities) {
    if (entities.any((e) => containsId(e))) {
      return false;
    }

    for (var entity in entities) {
      entity.id ??= Uuid().v4();
    }
    _cache.addAll(entities);
    dbProxy?.insertAll(entities);
    this.sort(notify: true);
    return true;
  }

  void remove(T entity) {
    _cache.remove(entity);
    dbProxy?.delete(entity);
    notifyListeners();
  }

  int indexOf(T entity) {
    return _cache.indexOf(entity);
  }

  int indexWhere(bool Function(T entity) test, [int start = 0]) {
    return _cache.indexWhere(test, start);
  }

  bool containsId(entity) => entity.id != null && getById(entity.id!) != null;

  T? getById(String id) {
    var min = 0;
    var max = _cache.length - 1;
    while (min <= max) {
      var mid = min + ((max - min) >> 1);
      var comp = _cache[mid].id!.compareTo(id);
      if (comp == 0) return _cache[mid];
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid - 1;
      }
    }
    return null;
  }

  void sort({bool notify = false}) {
    _cache.sort((e0, e1) => e0.id!.compareTo(e1.id!));
    if(notify) notifyListeners();
  }

  void forEach(void Function(T) action) {
    _cache.forEach(action);
  }

  void reportUpdate(T value) {
    dbProxy?.update(value);
    notifyListeners();
  }

  Iterable<T> where(bool Function(T) test) {  
    return _cache.where(test);
  }

  void _loadFromDatabase() async {
    if(dbProxy == null) return;
    final entities = await dbProxy!.selectAll() ?? [];
    _cache.addAll(entities);
    notifyListeners();
  }
}