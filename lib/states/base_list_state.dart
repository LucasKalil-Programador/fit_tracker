import 'dart:async';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class BaseListState<T extends BaseEntity> extends ChangeNotifier {
  final ProxyPart<T, dynamic>? dbProxy;
  final _completer = Completer<bool>();
  final List<T> _cache = [];
  bool useRollback;

  List<T> get clone => List<T>.from(_cache);
  bool get isEmpty => _cache.isEmpty;
  bool get isNotEmpty => _cache.isNotEmpty;
  int get length => _cache.length;
  T? get firstOrNull => _cache.isNotEmpty ? _cache.first : null;
  T? get lastOrNull => _cache.isNotEmpty ? _cache.last : null;

  T operator [](int index) => _cache[index];
  T get(int index) => _cache[index];

  bool containsId(entity) => entity.id != null && getById(entity.id!) != null;
  Iterable<T> where(bool Function(T) test) => _cache.where(test);
  int indexWhere(bool Function(T entity) test, [int start = 0]) => _cache.indexWhere(test, start);
  int indexOf(T entity) => _cache.indexOf(entity);

  void forEach(void Function(T) action) => _cache.forEach(action);

  Future<bool> waitLoaded() => _completer.future;


  BaseListState({this.dbProxy, bool loadDatabase = false, this.useRollback = false}) {
    if(loadDatabase) {
      _completer.complete(_loadFromDatabase());
    } else {
      _completer.complete(true);
    }
  }

  void operator []=(int index, T value) {
    if(index < 0 || index >= _cache.length) return;
    final oldValue = _cache[index];
    if(oldValue.id != value.id) return;

    _cache[index] = value;
    notifyListeners();

    dbProxy?.update(value)
      .then((proxyResult) {
        if(proxyResult.hasError && useRollback) {
          _cache[index] = oldValue;
          notifyListeners();
          logger.i('Rollback: reverted update due to database error.');
        }
      },);
  }
  
  bool add(T entity) {
    if(containsId(entity)) {
      return false;
    }
    entity.id ??= Uuid().v4();

    _cache.add(entity);
    this.sort(notify: true);

    dbProxy?.insert(entity)
      .then((proxyResult) {
        if(proxyResult.hasError && useRollback) {
          _cache.remove(entity);
          notifyListeners();
          logger.i('Rollback: removed entity after failed insert.');
        }
      },);
    return true;
  }

  void remove(T entity) {
    _cache.remove(entity);
    notifyListeners();

    dbProxy?.delete(entity)
      .then((proxyResult) {
        if(proxyResult.hasError && useRollback) {
          _cache.add(entity);
          notifyListeners();
          logger.i('Rollback: restored entity after failed delete.');
        }
      },);
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


  void sort({bool notify = false}) {
    _cache.sort((e0, e1) => e0.id!.compareTo(e1.id!));
    if(notify) notifyListeners();
  }

  void reportUpdate(T entity) {
    if(entity.id != null) {
      int index = _binarySearch(entity.id!);
      if (index < _cache.length && _cache[index].id == entity.id) {
        this[index] = entity;
      }
    }
  }

  T? getById(String id) {
    final index = _binarySearch(id);
    if (index < _cache.length && _cache[index].id == id) {
      return _cache[index];
    }
    return null;
  }

  // internals

  List<Map<String, Object?>> toJson() => _cache.map((e) => e.toMap()).toList();

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