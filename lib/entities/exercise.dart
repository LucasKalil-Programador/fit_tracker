
class Exercise {
  int? id;
  final String name;
  final int load;
  final int reps;
  final int sets;

  Exercise({
    this.id,
    required this.name,
    required this.load,
    required this.reps,
    required this.sets,
  });

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, load: $load kg, reps: $reps, sets: $sets)';
  }

  static Exercise fromMap(Map<String, Object?> e) {
    return Exercise(id: e['id'] as int, name: e['name'] as String, load: e['load'] as int, reps: e['reps'] as int, sets: e['sets'] as int);
  }
}
