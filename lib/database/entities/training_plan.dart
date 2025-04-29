/* 
CREATE TABLE training_plan(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
)
*/

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/base_entity.dart';
import 'package:fittrackr/database/entities/exercise.dart';

class TrainingPlan implements BaseEntity{
  int? id;
  final String name;
  late List<Exercise>? list;

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
      id: e['id'] as int,
      name: e['name'] as String,
    );
  }
}
