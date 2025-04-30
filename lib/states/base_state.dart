import 'package:fittrackr/database/entities/base_entity.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class BaseListState<T extends BaseEntity> extends ChangeNotifier {
  final List<T> _cache = [];

  bool get isEmpty => _cache.isEmpty;
  bool get isNotEmpty => _cache.isNotEmpty;
  int get length => _cache.length;

  T operator [](int index) => _cache[index];

  void operator []=(int index, T value) {
    _cache[index] = value;
    this.sort();
  }

  T get(int index) {
    return _cache[index];
  }

  void add(T entity) {
    entity.id = Uuid().v4();
    _cache.add(entity);
    this.sort();
  }

  void addAll(List<T> entity) async {
    for (var plan in entity) plan.id = Uuid().v4();
    _cache.addAll(entity);
    this.sort();
  }

  void remove(T entity) async {
    _cache.remove(entity);
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
}