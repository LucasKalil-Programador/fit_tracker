/* 
CREATE TABLE exercise(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  amount INTEGER NOT NULL,
  reps INTEGER NOT NULL,
  sets INTEGER NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('Cardio', 'Musclework'))
) 
*/

import 'package:fittrackr/database/entities/base_entity.dart';

enum ExerciseType {Cardio, Musclework}

class Exercise implements BaseEntity {
  int? id;
  final String name;
  final int amount;
  final int reps;
  final int sets;
  final ExerciseType type;

  Exercise({
    this.id,
    required this.name,
    required this.amount,
    required this.reps,
    required this.sets,
    required this.type,
  });

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, amount: $amount, reps: $reps, sets: $sets, type: ${type.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        other.id == this.id &&
        other.name == this.name &&
        other.amount == this.amount &&
        other.reps == this.reps &&
        other.sets == this.sets &&
        other.type == this.type;
  }

  static Exercise fromMap(Map<String, Object?> e) {
    return Exercise(
      id: e['id'] as int,
      name: e['name'] as String,
      amount: e['amount'] as int,
      reps: e['reps'] as int,
      sets: e['sets'] as int,
      type: ExerciseType.values.byName(e['type'] as String),
    );
  }
}
