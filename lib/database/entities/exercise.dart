import 'package:fittrackr/database/entities/base_entity.dart';

enum ExerciseType {Cardio, Musclework}

class Exercise implements BaseEntity {
  String? id;
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

  @override
  int get hashCode => Object.hash(id, name, amount, reps, sets, type);

  static Exercise? fromMap(Map<String, Object?> e) {
    final uuid = e["uuid"];
    final name = e["name"];
    final amount = e["amount"];
    final reps = e["reps"];
    final sets = e["sets"];
    final type = e["type"];
    if(uuid is String && name is String && amount is int && 
       reps is int    && sets is int    && type is String) {
      return Exercise(
        id: uuid,
        name: name,
        amount: amount,
        reps: reps,
        sets: sets,
        type: ExerciseType.values.byName(type),
      );
    }

    return null;
  }
}
