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



import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';

class Report<T> {
  int? id;
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

  static Report<T> fromMap<T>(Map<String, Object?> e) {
    Object object = Object();
    if(T == Exercise) {
      object = Exercise.fromMap(e);
      (object as Exercise).id = e['exercise_id'] as int;
    } else if(T == TrainingPlan) {
      object = TrainingPlan.fromMap(e);
      (object as TrainingPlan).id = e['training_plan_id'] as int;
    }
    
    return Report(
      id: e['id'] as int,
      data: e['data'] as String,
      reportDate: e['report_date'] as int,
      object: object as T,
    );
  }
}
