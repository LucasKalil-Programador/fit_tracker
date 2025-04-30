/* 
CREATE TABLE training_plan(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
)
*/

import 'package:fittrackr/database/entities/base_entity.dart';

class TrainingPlan implements BaseEntity{
  String? id;
  final String name;
  late List<String>? list;

  TrainingPlan({
    this.id,
    required this.name, 
    this.list,
  });

  @override
  String toString() {
    return 'TrainingPlan(id: $id, name: $name, list: ${this.list})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainingPlan && other.id == this.id && other.name == this.name;

  }

  static TrainingPlan fromMap(Map<String, Object?> e) {
    return TrainingPlan(
      id: e['id'] as String,
      name: e['name'] as String,
      list: e['list'] as List<String>,
    );
  }
}
