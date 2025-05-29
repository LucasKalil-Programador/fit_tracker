
import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() async {
  
  test('Exercise insert test', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);

    final result = await proxy.exercise.insert(exercise);
    expect(result.containsKey("success"), true);
  });

  test('Exercise insert error same id', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);

    var result = await proxy.exercise.insert(exercise);
    expect(result.containsKey("success"), true);

    result = await proxy.exercise.insert(exercise);
    expect(result.containsKey("error"), true);
  });

  test('Exercise delete test', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);

    var result = await proxy.exercise.insert(exercise);
    expect(result.containsKey("success"), true);

    result = await proxy.exercise.delete(exercise);
    expect(result.containsKey("success"), true);
  });

  test('Exercise update test', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);

    var result = await proxy.exercise.insert(exercise);
    expect(result.containsKey("success"), true);

    Exercise exercise1 = Exercise(id: exercise.id, name: "test 2", amount: 20, reps: 25, sets: 411, type: ExerciseType.cardio);

    result = await proxy.exercise.update(exercise1);
    expect(result.containsKey("success"), true);
  });

  test('Exercise select all test', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise1 = Exercise(id: Uuid().v4(), name: "test-1", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise2 = Exercise(id: Uuid().v4(), name: "test-2", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise3 = Exercise(id: Uuid().v4(), name: "test-3", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);

    await proxy.exercise.insert(exercise1);
    await proxy.exercise.insert(exercise2);
    await proxy.exercise.insert(exercise3);

    Exercise exercise4 = Exercise(id: exercise1.id, name: exercise1.name, amount: 12, reps: 18, sets: 42, type: ExerciseType.cardio);
    await proxy.exercise.update(exercise4);

    final result = await proxy.exercise.selectAll();
    expect(result.containsKey("success"), true);
    expect(result.containsKey("data"), true);

    final exercises = result["data"] as List<Exercise?>;
    
    expect(exercises.isNotEmpty, true);
    expect(exercises.contains(exercise1), false);
    expect(exercises.contains(exercise2), true);
    expect(exercises.contains(exercise3), true);
    expect(exercises.contains(exercise4), true);
  });


  test('TrainingPlan insert test', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    final result = await proxy.trainingPlan.insert(plan);

    expect(result.containsKey("success"), true);
  });

  test('TrainingPlan insert error same id', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    
    var result = await proxy.trainingPlan.insert(plan);
    expect(result.containsKey("success"), true);

    result = await proxy.trainingPlan.insert(plan);
    expect(result.containsKey("error"), true);
  });

  test('TrainingPlan delete test', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    
    var result = await proxy.trainingPlan.insert(plan);
    expect(result.containsKey("success"), true);

    result = await proxy.trainingPlan.delete(plan);
    expect(result.containsKey("success"), true);
  });

  test('TrainingPlan update test', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    
    var result = await proxy.trainingPlan.insert(plan);
    expect(result.containsKey("success"), true);

    TrainingPlan plan1 = TrainingPlan(id: plan.id, name: "Treino B", list: plan.list);

    result = await proxy.trainingPlan.update(plan1);
    expect(result.containsKey("success"), true);
  });

  test('TrainingPlan select all test', () async {
    final proxy = await DatabaseProxy.instance;
    Exercise exercise1 = Exercise(id: Uuid().v4(), name: "test-1", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise2 = Exercise(id: Uuid().v4(), name: "test-2", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise3 = Exercise(id: Uuid().v4(), name: "test-3", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise5 = Exercise(id: Uuid().v4(), name: "test-3", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);

    await proxy.exercise.insert(exercise1);
    await proxy.exercise.insert(exercise2);
    await proxy.exercise.insert(exercise3);
    await proxy.exercise.insert(exercise5);

    TrainingPlan trainingPlan1 = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise1.id!]);
    TrainingPlan trainingPlan2 = TrainingPlan(id: Uuid().v4(), name: "Treino B", list: [exercise1.id!, exercise2.id!]);
    TrainingPlan trainingPlan3 = TrainingPlan(id: Uuid().v4(), name: "Treino C", list: [exercise1.id!, exercise3.id!]);
    TrainingPlan trainingPlan5 = TrainingPlan(id: Uuid().v4(), name: "Treino F", list: [exercise1.id!, exercise3.id!]);

    await proxy.trainingPlan.insert(trainingPlan1);
    await proxy.trainingPlan.insert(trainingPlan2);
    await proxy.trainingPlan.insert(trainingPlan3);
    await proxy.trainingPlan.insert(trainingPlan5);

    TrainingPlan trainingPlan4 = TrainingPlan(id: trainingPlan3.id, name: "Treino D", list: trainingPlan3.list);
    await proxy.trainingPlan.update(trainingPlan4);
    await proxy.trainingPlan.delete(trainingPlan5);

    final result = await proxy.trainingPlan.selectAll();
    expect(result.containsKey("success"), true);
    expect(result.containsKey("data"), true);

    final exercises = result["data"] as List<TrainingPlan?>;
    
    expect(exercises.isNotEmpty, true);
    expect(exercises.contains(trainingPlan3), false);
    expect(exercises.contains(trainingPlan5), false);
    expect(exercises.contains(trainingPlan1), true);
    expect(exercises.contains(trainingPlan2), true);
    expect(exercises.contains(trainingPlan4), true);
  });


  test('Metadata insert test', () async {
    final proxy = await DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config", "test");
    final result = await proxy.metadata.insert(entry);
    
    expect(result.containsKey("success"), true);
  });

  test('Metadata insert same id', () async {
    final proxy = await DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config-3", "test");

    var result = await proxy.metadata.insert(entry);
    expect(result.containsKey("success"), true);

    entry = MapEntry(entry.key, "test-2");

    result = await proxy.metadata.insert(entry);
    expect(result.containsKey("error"), true);
  });

  test('Metadata delete test', () async {
    final proxy = await DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config-2", "test");

    var result = await proxy.metadata.insert(entry);
    expect(result.containsKey("success"), true);

    result = await proxy.metadata.delete(entry);
    expect(result.containsKey("success"), true);
  });

  test('Metadata update test', () async {
    final proxy = await DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config-500", "test");

    var result = await proxy.metadata.insert(entry);
    expect(result.containsKey("success"), true);

    entry = MapEntry(entry.key, "test-500");
    result = await proxy.metadata.update(entry);
    expect(result.containsKey("success"), true);
  });

  test('Metadata select all test', () async {
    final proxy = await DatabaseProxy.instance;
    MapEntry<String, String> entry1 = MapEntry("config-41", "test-1");
    MapEntry<String, String> entry2 = MapEntry("config-42", "test-2");
    MapEntry<String, String> entry3 = MapEntry("config-43", "test-3");
    MapEntry<String, String> entry4 = MapEntry("config-44", "test-4");
    MapEntry<String, String> entry5 = MapEntry("config-45", "test-5");

    await proxy.metadata.insert(entry1);
    await proxy.metadata.insert(entry2);
    await proxy.metadata.insert(entry3);
    await proxy.metadata.insert(entry4);
    await proxy.metadata.insert(entry5);

    entry5 = MapEntry("config-45", "test-90");
    await proxy.metadata.update(entry5);

    await proxy.metadata.delete(entry4);

    final result = await proxy.metadata.selectAll();
    
    expect(result.containsKey("success"), true);
    expect(result.containsKey("data"), true);

    final data = (result["data"] as List<Map<String, String>>).map((e) => e.toString(),);
    
    expect(data.contains({"key": entry1.key, "value": entry1.value}.toString()), true);
    expect(data.contains({"key": entry2.key, "value": entry2.value}.toString()), true);
    expect(data.contains({"key": entry3.key, "value": entry3.value}.toString()), true);
    expect(data.contains({"key": entry4.key, "value": entry4.value}.toString()), false);
    expect(data.contains({"key": entry5.key, "value": entry5.value}.toString()), true);
  });
}
