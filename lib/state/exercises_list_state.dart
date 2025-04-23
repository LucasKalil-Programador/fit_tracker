import 'package:fittrackr/widgets/exercise_form.dart';
import 'package:flutter/material.dart';

class ExerciseListState extends ChangeNotifier {
  final List<Exercise> _exercisesList = [];
  
  List<Exercise> get exercisesList => List.unmodifiable(_exercisesList);

  void addExercise(Exercise exercise) {
    _exercisesList.add(exercise);
    notifyListeners();
  }

  void removeExercise(Exercise exercise) {
    _exercisesList.remove(exercise);
    notifyListeners();
  }

  void clearExercises() {
    _exercisesList.clear();
    notifyListeners();
  }
}