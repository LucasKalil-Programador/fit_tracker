import 'dart:convert';
import 'package:fittrackr/database/entities/entity.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:flutter/foundation.dart';

class TrainingHistory implements BaseEntity {
  @override
  String? id;
  final String trainingName;
  final List<ExerciseSnapshot> exercises;
  final int dateTime;

  TrainingHistory({
    this.id,
    required this.trainingName,
    required this.exercises,
    required this.dateTime,
  });

  TrainingHistory.fromTrainingPlan({
    this.id,
    required TrainingPlan plan,
    required List<Exercise> exercises,
    required this.dateTime,
  }) : trainingName = plan.name,
       exercises = exercises.map((e) => ExerciseSnapshot(name: e.name, amount: e.amount, reps: e.reps, sets: e.sets, type: e.type.name)).toList();

  @override
  String toString() {
    return 'TrainingHistory(id: $id, trainingName: $trainingName, exercises: $exercises, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainingHistory &&
        other.trainingName == trainingName &&
        listEquals(other.exercises, exercises) &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode => Object.hash(trainingName, exercises, dateTime);

  @override
  Map<String, Object?> toMap() {
    return {
      "uuid": id,
      "trainingName": trainingName,
      "exercises": jsonEncode(exercises.map((e) => e.toMap()).toList()),
      "dateTime": dateTime,
    };
  }

  static TrainingHistory? fromMap(Map<String, Object?> e) {
    final uuid = e["uuid"];
    final trainingName = e["trainingName"];
    final exercises = e["exercises"];
    final dateTime = e["dateTime"];

    if (uuid is String && trainingName is String && exercises is String && dateTime is int) {
      return TrainingHistory(
        id: uuid,
        trainingName: trainingName,
        exercises: (jsonDecode(exercises) as List)
            .map((x) => ExerciseSnapshot.fromMap(Map<String, Object?>.from(x)))
            .toList(),
        dateTime: dateTime,
      );
    }
    return null;
  }
}

class ExerciseSnapshot {
  final String name;
  final int amount;
  final int reps;
  final int sets;
  final String type;

  ExerciseSnapshot({
    required this.name,
    required this.amount,
    required this.reps,
    required this.sets,
    required this.type,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseSnapshot &&
        other.name == name &&
        other.amount == amount &&
        other.reps == reps &&
        other.sets == sets &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(name, amount, reps, sets, type);

  Map<String, Object?> toMap() {
    return {
      "name": name,
      "amount": amount,
      "reps": reps,
      "sets": sets,
      "type": type,
    };
  }

  static ExerciseSnapshot fromMap(Map<String, Object?> e) {
    return ExerciseSnapshot(
      name: e["name"] as String,
      amount: e["amount"] as int,
      reps: e["reps"] as int,
      sets: e["sets"] as int,
      type: e["type"] as String,
    );
  }

  @override
  String toString() {
    return 'ExerciseSnapshot(name: $name, amount: $amount, reps: $reps, sets: $sets, type: $type)';
  }
}