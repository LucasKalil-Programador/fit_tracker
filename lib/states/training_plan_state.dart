import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:flutter/material.dart';

class TrainingPlanState extends ChangeNotifier {
  final List<TrainingPlan> _cache = [];
  List<TrainingPlan> get plans => List.unmodifiable(_cache);

  Future<bool> add(TrainingPlan plan) async {
    int id = await DatabaseHelper().insertTrainingPlan(plan);
    if(id > 0) {
      _cache.add(plan);
      this._sort();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> update(TrainingPlan plan) async {
    int result = await DatabaseHelper().updateTrainingPlan(plan);
    if(result > 0) {
      int index = _cache.indexWhere((a) => a.id == plan.id);
      if(index != -1) {
        _cache[index] = plan;
      }
      this._sort();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> remove(TrainingPlan plan) async {
    int result = await DatabaseHelper().deleteTrainingPlan(plan);
    if(result > 0) {
      _cache.remove(plan);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loadDatabase() async {
    _cache.clear();
    _cache.addAll(await DatabaseHelper().selectAllTrainingPlan());
    this._sort();
    notifyListeners();
    return _cache.isNotEmpty;
  }

  void _sort() {
    _cache.sort((a, b) => a.name.compareTo(b.name));
  }

  TrainingPlan? getById(int id) {
    int index = _cache.indexWhere((a) => a.id == id);
    if(index != -1) {
      return _cache[index];
    }
    return null;
  }
}