import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/entities/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseListState extends ChangeNotifier {
  final List<Exercise> _exercises = [];
  
  List<Exercise> get exercises => List.unmodifiable(_exercises);

  Future<bool> addExercise(Exercise exercise) async {
    final int result = await DatabaseHelper().insertExercise(exercise);
    if(result > 0) {
      _exercises.add(exercise);
      _exercises.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
    } 
    return result > 0;
  }

  Future<bool> updateExercise(Exercise exercise) async {
    final index = _exercises.indexWhere((e) => e.id == exercise.id);
    if(index == -1) return false;

    final int result = await DatabaseHelper().updateExercise(exercise);
    if (result > 0) {
      _exercises[index] = exercise;
      _exercises.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> removeExercise(Exercise exercise) async {
    final int result = await DatabaseHelper().deleteExercise(exercise);
    if(result > 0) {
      _exercises.remove(exercise);
      notifyListeners();
    }
    return result > 0;
  }

  Future clearExercises() async {
    await DatabaseHelper().clearExercise();
    _exercises.clear();
    notifyListeners();
  }

  Future<bool> loadDatabase() async {
    List<Exercise> storageExircese = await DatabaseHelper().selectAll();
    _exercises.addAll(storageExircese);
    notifyListeners();
    
    return storageExircese.isNotEmpty;
  }
}