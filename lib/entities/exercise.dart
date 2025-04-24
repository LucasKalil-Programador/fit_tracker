
import 'package:uuid/uuid.dart';

class Exercise {
  final String id;
  final String name;
  final int load;
  final int reps;
  final int sets;

  Exercise({
    String? id,
    required this.name,
    required this.load,
    required this.reps,
    required this.sets,
  }) : id = id ?? const Uuid().v4();

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, load: $load kg, reps: $reps, sets: $sets)';
  }
}
