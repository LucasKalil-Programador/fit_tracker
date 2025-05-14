import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities.dart';

/* CREATE TABLE metadata(
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
); 
*/
Future<Map<String, String>> loadMetadata([bool debug = false]) async {
  final db = await DatabaseHelper().database;
  final data = await db.queryCursor('metadata');

  final Map<String, String> metadata = {};
  while (await data.moveNext()) {
    final element = data.current;
    final key = element["key"];
    final value = element["value"];
    if(key is String && value is String) {
      metadata[key] = value;
    } else if(debug) {
      print("Metadata load fail: \"$element\"");
    } 
  }

  if(debug) print("Loaded metadata: ${metadata.length}");
  return metadata;
}

/* CREATE TABLE exercise(
  uuid TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  amount INTEGER NOT NULL,
  reps INTEGER NOT NULL,
  sets INTEGER NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('Cardio', 'Musclework'))
);
*/
Future<List<Exercise>> loadExercises([bool debug = false]) async {
  final db = await DatabaseHelper().database;
  final data = await db.queryCursor('exercise');

  final List<Exercise> exercises = [];
  while(await data.moveNext()) {
    final element = data.current;
    final exercise = Exercise.fromMap(element);
    if(exercise != null) {
      exercises.add(exercise);
    } else if(debug) {
      print("Exercises load fail: \"$element\"");
    } 
  }

  if(debug) print("Loaded exercises: ${exercises.length}");
  return exercises;
}

/* CREATE TABLE training_plan(
  uuid TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  list TEXT NOT NULL
); 
*/
Future<List<TrainingPlan>> loadTrainingPlans([bool debug = false]) async {
  final db = await DatabaseHelper().database;
  final data = await db.queryCursor('training_plan');

  final List<TrainingPlan> trainingPlans = [];
  while(await data.moveNext()) {
    final element = data.current;
    final plan = TrainingPlan.fromMap(element);
    if(plan != null) {
      trainingPlans.add(plan);
    } else if(debug) {
      print("TrainingPlans load fail: \"$element\"");
    } 
  }

  if(debug) print("Loaded TrainingPlan: ${trainingPlans.length}");
  return trainingPlans;
}