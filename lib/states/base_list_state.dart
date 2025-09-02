import 'dart:async';

import 'package:fittrackr/database/entities/entity.dart';
import 'package:fittrackr/database/proxy/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class BaseListState<T extends BaseEntity> extends ChangeNotifier {
  abstract final String serializationKey;

  final ProxyPart<T, dynamic>? dbProxy;
  final _completer = Completer<bool>();
  final List<T> _cache = [];

  List<T> get clone => List<T>.from(_cache);
  
  bool get isEmpty => _cache.isEmpty;
  bool get isNotEmpty => _cache.isNotEmpty;
  int get length => _cache.length;
  T? get firstOrNull => _cache.isNotEmpty ? _cache.first : null;
  T? get lastOrNull => _cache.isNotEmpty ? _cache.last : null;

  T operator [](int index) => _cache[index];
  T get(int index) => _cache[index];

  bool containsId(T entity) => entity.id != null && getById(entity.id!) != null;
  Iterable<T> where(bool Function(T) test) => _cache.where(test);
  T reduce(T Function(T value, T element) combine) => _cache.reduce(combine);
  bool any(bool Function(T) test) => _cache.any(test);
  int indexWhere(bool Function(T entity) test, [int start = 0]) => _cache.indexWhere(test, start);
  int indexOf(T entity) => _cache.indexOf(entity);

  void forEach(void Function(T) action) => _cache.forEach(action);

  Future<bool> waitLoad() => _completer.future;

  BaseListState({this.dbProxy, bool loadDatabase = false}) {
    if(loadDatabase) {
      _completer.complete(_loadFromDatabase());
    } else {
      _completer.complete(true);
    }
  }
  
  // Methods

  Future<bool> add(T entity) async {
    if(containsId(entity)) return false;
    entity.id ??= Uuid().v4();

    if(dbProxy != null) {
      final result = await dbProxy!.insert(entity);
      if(result.hasError) return false;
    }

    _cache.add(entity);
    this.sort(notify: true);
    return true;
  }

  Future<bool> addAll(List<T> entities) async {
    if (entities.any((e) => containsId(e))) return false;

    for (var entity in entities) {
      entity.id ??= Uuid().v4();
    }

    if (dbProxy == null) {
      _cache.addAll(entities);
      this.sort(notify: true);
      return true;
    }

    final result = await dbProxy!.insertAll(entities);
    if(result.notHasError) {
      _cache.addAll(entities);
      this.sort(notify: true);
    }
    return result.notHasError;
  }

  Future<bool> reportUpdate(T entity) async {
    final index = _cache.indexWhere((e) => e.id == entity.id);
    if (index == -1) return false;

    if(dbProxy != null) {
      final result = await dbProxy!.update(entity);
      if(result.hasError) return false;
    }

    _cache[index] = entity;
    notifyListeners();
    return true;
  }

  Future<bool> remove(T entity) async {
    if (!containsId(entity)) return false;

    if (dbProxy != null) {
      final result = await dbProxy!.delete(entity);
      if (result.hasError) return false;
    }

    _cache.remove(entity);
    notifyListeners();
    return true;
  }

  Future<bool> clear() async {
    if (dbProxy == null) {
      _cache.clear();
      notifyListeners();
      return true;
    }
    
    final result = await dbProxy!.deleteAll();
    if(result.notHasError) {
      _cache.clear();
      notifyListeners();
    }

    return result.notHasError;
  }

  // Aux methods

  void sort({bool notify = false}) {
    _cache.sort((e0, e1) => e0.id!.compareTo(e1.id!));
    if(notify) notifyListeners();
  }

  T? getById(String id) {
    final index = _binarySearch(id);
    if (index < _cache.length && _cache[index].id == id) {
      return _cache[index];
    }
    return null;
  }

  // internals

  int _binarySearch(String id) {
    int min = 0;
    int max = _cache.length;
    while (min < max) {
      final int mid = min + ((max - min) >> 1);
      final String element = _cache[mid].id!;
      final int comp = element.compareTo(id);
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return min;
  }

  Future<bool> _loadFromDatabase() async {
    if(dbProxy == null) return true;
    final entities = await dbProxy!.selectAll();
    if(entities.result == null) return false;

    _cache.addAll(entities.result!);
    sort(notify: true);
    return true;
  }
}