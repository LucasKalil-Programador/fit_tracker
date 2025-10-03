import 'dart:convert';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/utils/assets.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:flutter/services.dart';

Future<void> generateDB(ExercisesState exercisesState, TrainingPlanState trainingPlanState, ReportTableState reportTableState, ReportState reportState) async {
  final jsonString = await rootBundle.loadString(Assets.exercisesPTBR);
  Map<String, dynamic> data = jsonDecode(jsonString);
  
  List<Exercise> exercises = [];
  for (var category in data.keys) {
    exercises.addAll(_getExercises(data, category));
  }
  exercisesState.addAll(exercises);
}

List<Exercise> _getExercises(Map<String, dynamic> data, String category) {
  if (data.containsKey(category)) {
    final names = data[category] as List<dynamic>;
    List<Exercise> exercises = [];
    
    for (var name in names) {
      exercises.add(
        Exercise(
          name: name,
          amount: 10,
          reps: 15,
          sets: 3,
          type: ExerciseType.musclework,
        ),
      );
    }
    return exercises;
  }
  logger.w("Group not exist $category");
  return List.empty();
}