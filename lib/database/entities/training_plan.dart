/* 
CREATE TABLE training_plan(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
)
*/

class TrainingPlan {
  int? id;
  final String name;

  TrainingPlan({
    this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'TrainingPlan(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainingPlan && other.id == this.id && other.name == this.name;

  }

  static TrainingPlan fromMap(Map<String, Object?> e) {
    return TrainingPlan(
      id: e['id'] as int,
      name: e['name'] as String,
    );
  }
}
