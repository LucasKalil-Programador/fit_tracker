import 'package:fittrackr/database/entities/entity.dart';

enum ExerciseType {cardio, musclework}

class Exercise implements BaseEntity {
  @override
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
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.reps == reps &&
        other.sets == sets &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(id, name, amount, reps, sets, type);

  @override
  Map<String, Object?> toMap() {
    return {
      "uuid": id,
      "name": name,
      "amount": amount,
      "reps": reps,
      "sets": sets,
      "type": type.name
    };
  }

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
  
  @override
  // TODO: implement isValid
  bool get isValid => true;
}
