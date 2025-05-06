import 'package:fittrackr/database/entities/base_entity.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum UpdateEvent { insert, update, remove }

abstract class BaseListState<T extends BaseEntity> extends ChangeNotifier {
  final Map<UpdateEvent, List<T>> _updatePatch = {
    UpdateEvent.insert: [],
    UpdateEvent.update: [],
    UpdateEvent.remove: [],
  };
  final List<T> _cache = [];

  List<T> get clone => List<T>.from(_cache);
  bool get isEmpty => _cache.isEmpty;
  bool get isNotEmpty => _cache.isNotEmpty;
  int get length => _cache.length;

  T get first => _cache.first;
  T get last => _cache.last;

  T operator [](int index) => _cache[index];

  void operator []=(int index, T value) {
    _cache[index] = value;
    _updatePatch[UpdateEvent.update]!.add(value);
    this.sort();
  }

  T get(int index) {
    return _cache[index];
  }

  void add(T entity) {
    entity.id = Uuid().v4();
    _cache.add(entity);
    _updatePatch[UpdateEvent.insert]!.add(entity);
    this.sort();
  }

  void addAll(List<T> entities) {
    for (var plan in entities) plan.id = Uuid().v4();
    _cache.addAll(entities);
    _updatePatch[UpdateEvent.insert]!.addAll(entities);
    this.sort();
  }

  void remove(T entity) {
    _cache.remove(entity);
    _updatePatch[UpdateEvent.remove]!.add(entity);
    notifyListeners();
  }

  int indexOf(T entity) {
    return _cache.indexOf(entity);
  }

  int indexWhere(bool test(T entity), [int start = 0]) {
    return _cache.indexWhere(test, start);
  }

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
    print("error");
    return null;
  }

  void sort() {
    _cache.sort((e0, e1) => e0.id!.compareTo(e1.id!));
    notifyListeners();
  }

  void forEach(void Function(T) action) {
    _cache.forEach(action);
  }

  void reportUpdate(T value) {
    _updatePatch[UpdateEvent.update]!.add(value);
    notifyListeners();
  }

  Map<UpdateEvent, List<T>> flushUpdatePatch() {
    final retrMap = Map<UpdateEvent, List<T>>.from(_updatePatch);
    _updatePatch[UpdateEvent.insert] = [];
    _updatePatch[UpdateEvent.update] = [];
    _updatePatch[UpdateEvent.remove] = [];
    return retrMap;
  }

  void setList(List<T> list) {
    _cache.clear();
    _cache.addAll(list);
    sort();
  }

  Iterable<T> where(bool Function(T) test) {
    return _cache.where(test);
  }
}