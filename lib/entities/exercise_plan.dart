import 'package:fittrackr/entities/exercise.dart';
import 'package:uuid/uuid.dart';

class ExercisePlan {
  final String id;
  final String name;
  final List<ExercisePlanRecipient> exercises;

  ExercisePlan({
    String? id,
    required this.name,
    required this.exercises,
  }) : id = id ?? const Uuid().v4();

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