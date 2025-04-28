import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:flutter/material.dart';

class ExercisesState extends ChangeNotifier {
  final List<Exercise> _cache = [];
  List<Exercise> get exercises => List.unmodifiable(_cache);

  Future<bool> add(Exercise exercise) async {
    int id = await DatabaseHelper().insertExercise(exercise);
    if(id > 0) {
      _cache.add(exercise);
      this._sort();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> update(Exercise exercise) async {
    int result = await DatabaseHelper().updateExercise(exercise);
    if(result > 0) {
      int index = _cache.indexWhere((a) => a.id == exercise.id);
      if(index != -1) {
        _cache[index] = exercise;
      }
      this._sort();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> remove(Exercise exercise) async {
    int result = await DatabaseHelper().deleteExercise(exercise);
    if(result > 0) {
      _cache.remove(exercise);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loadDatabase() async {
    _cache.clear();
    _cache.addAll(await DatabaseHelper().selectAllExercise());
    this._sort();
    notifyListeners();
    return _cache.isNotEmpty;
  }

  void _sort() {
    _cache.sort((a, b) => a.name.compareTo(b.name));
  }
}