/* 
CREATE TABLE report_exercise(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  data TEXT NOT NULL,
  report_date INTEGER NOT NULL,
  exercise_id INTEGER NOT NULL,
  FOREIGN KEY (exercise_id) REFERENCES exercise(id)
)

CREATE TABLE report_training_plan(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  data TEXT NOT NULL,
  report_date INTEGER NOT NULL,
  training_plan_id INTEGER NOT NULL,
  FOREIGN KEY (training_plan_id) REFERENCES training_plan(id)
)
*/



import 'package:fittrackr/database/entities/base_entity.dart';

class Report<T> implements BaseEntity {
  String? id;
  final String data;
  final int reportDate;
  final T object;

  Report({
    this.id,
    required this.data,
    required this.reportDate,
    required this.object,
  });

  @override
  String toString() {
    return 'Report(id: $id, data: $data, reportDate: $reportDate, object: $object)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Report &&
        other.id == this.id &&
        other.data == this.data &&
        other.reportDate == this.reportDate &&
        other.object == this.object;
  }
}
