import 'package:fittrackr/entities/exercise.dart';
import 'package:uuid/uuid.dart';

class ExercisePlan {
  int? id;
  final String name;
  final List<ExercisePlanRecipient> exercises;

  ExercisePlan({
    int? id,
    required this.name,
    required this.exercises,
  });

  @override
  String toString() {
    return 'ExercisePlan(id: $id, name: $name, exercises: $exercises)';
  }
}

class ExercisePlanRecipient {
  final Exercise exercise;
  bool done = false;

  ExercisePlanRecipient({required this.exercise});  

  @override
  String toString() {
    return 'ExercisePlanEecipient(Exercise: $exercise, done: $done)';
  }
}