import 'package:flutter/foundation.dart';

enum ExerciseType {cardio, musclework}

@immutable
class Exercise {
  final String? id;
  final String name;
  final int amount;
  final int reps;
  final int sets;
  final ExerciseType type;
  final String category;

  const Exercise({
    this.id,
    required this.name,
    required this.amount,
    required this.reps,
    required this.sets,
    required this.type,
    required this.category,
  });

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, amount: $amount, reps: $reps, sets: $sets, type: ${type.name}, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.reps == reps &&
        other.sets == sets &&
        other.type == type &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(id, name, amount, reps, sets, type, category);

  Map<String, Object?> toMap() {
    return {
      "uuid": id,
      "name": name,
      "amount": amount,
      "reps": reps,
      "sets": sets,
      "type": type.name,
      "category": category,
    };
  }

  Exercise withValues({
    String? id,
    String? name,
    int? amount,
    int? reps,
    int? sets,
    ExerciseType? type,
    String? category,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      reps: reps ?? this.reps,
      sets: sets ?? this.sets,
      type: type ?? this.type,
      category: category ?? this.category,
    );
  }

  static Exercise? fromMap(Map<String, Object?> e) {
    final uuid = e["uuid"];
    final name = e["name"];
    final amount = e["amount"];
    final reps = e["reps"];
    final sets = e["sets"];
    final type = e["type"];
    final category = e["category"];
    
    if(uuid is String && name is String && amount is int && 
       reps is int    && sets is int    && type is String && category is String) {
      return Exercise(
        id: uuid,
        name: name,
        amount: amount,
        reps: reps,
        sets: sets,
        type: ExerciseType.values.byName(type),
        category: category,
      );
    }
    return null;
  }
}