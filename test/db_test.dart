import 'dart:math';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/metadata.dart';
import 'package:fittrackr/database/entities/report.dart';
import 'package:fittrackr/database/entities/tag.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:flutter_test/flutter_test.dart';


void main() async {
  group("Database test", () {
    TagDbTest();
    ExerciseDbTest();
    MetadataDbTest();
    TrainingPlanDbTest();
    ReportExerciseDbTest();
    ReportTrainingPlanDbTest();
  });
}

void ExerciseDbTest() {
  
  test("Exercise Insertion failed", () async {
    Exercise exercise = Exercise(name: "Rosca direta", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    var databaseHelper = DatabaseHelper();
  
    int newId = await databaseHelper.insertExercise(exercise);
  
    expect(newId > 0, true);
  });
  
  test("Exercise Delete failed", () async {
    Exercise exercise = Exercise(name: "Rosca direta", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertExercise(exercise);
    int result = await databaseHelper.deleteExercise(exercise);
  
    expect(result > 0, true);
  });
  
  test("Exercise Update failed", () async {
    Exercise exercise = Exercise(name: "Rosca direta", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertExercise(exercise);
    Exercise newExercise = Exercise(id: exercise.id, name: "Rosca inclinada", amount: 2, reps: 2, sets: 2, type: ExerciseType.Musclework);
    int result = await databaseHelper.updateExercise(newExercise);
  
    expect(result > 0, true);
  });
  
  test("Exercise SelectAll failed", () async {
    Exercise exercise1 = Exercise(name: "Rosca direta", amount: 1, reps: 2, sets: 3, type: ExerciseType.Musclework);
    Exercise exercise2 = Exercise(name: "Rosca inclinada", amount: 4, reps: 5, sets: 6, type: ExerciseType.Musclework);
    Exercise exercise3 = Exercise(name: "Rosca scott", amount: 7, reps: 8, sets: 9, type: ExerciseType.Musclework);
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertExercise(exercise1);
    await databaseHelper.insertExercise(exercise2);
    await databaseHelper.insertExercise(exercise3);
  
    List<Exercise> entries = await databaseHelper.selectAllExercise();
    
    expect(entries.contains(exercise1), true);
    expect(entries.contains(exercise2), true);
    expect(entries.contains(exercise2), true);
    expect(entries.length > 3, true);
  });
  
  test("Exercise Select failed", () async {
    Exercise exercise = Exercise(name: "Rosca unilateral", amount: 10, reps: 11, sets: 12, type: ExerciseType.Cardio);
    var databaseHelper = DatabaseHelper();
  
    int newId = await databaseHelper.insertExercise(exercise);
    Exercise? loaded = await databaseHelper.selectExercise(newId);
  
    expect(loaded, exercise);
  });

   test("Exercise set get exercise tag list failed", () async {
    var databaseHelper = DatabaseHelper();

    Exercise exercise = Exercise(name: "Rosca unilateral", amount: 10, reps: 11, sets: 12, type: ExerciseType.Cardio);
    await databaseHelper.insertExercise(exercise);

    List<Tag> tags = [];

    for(int i = 0; i < 50; i++) {
      Tag tag = Tag(name: "tag:$i");
      await databaseHelper.insertTag(tag);
      tags.add(tag);

      await databaseHelper.setTagList(exercise, tags);
      List<Tag> loaded = await databaseHelper.getTagList(exercise);
      expect(loaded, tags);
    }

    while(tags.isNotEmpty) {
      tags.shuffle();
      tags.removeLast();

      await databaseHelper.setTagList(exercise, tags);
      List<Tag> loaded = await databaseHelper.getTagList(exercise);
      tags.sort((a, b) => (a.id as int).compareTo(b.id as int));
      expect(loaded, tags);
    }
  });
}

void MetadataDbTest() {
  test("Metadata Insertion failed", () async {
    Metadata metadata = Metadata(key: "config1", value: "theme:dark,unit:Kg");
    var databaseHelper = DatabaseHelper();
  
    int newId = await databaseHelper.insertMetadata(metadata);
  
    expect(newId > 0, true);
  });
  
  test("Metadata Delete failed", () async {
    Metadata metadata = Metadata(key: "config2", value: "theme:dark,unit:Kg");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertMetadata(metadata);
    int result = await databaseHelper.deleteMetadata(metadata);
  
    expect(result > 0, true);
  });
  
  test("Metadata Update failed", () async {
    Metadata metadata = Metadata(key: "config3", value: "theme:dark,unit:Kg");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertMetadata(metadata);
    Metadata newMetadata = Metadata(id: metadata.id, key: "config", value: "theme:light,unit:Kg");
    int result = await databaseHelper.updateMetadata(newMetadata);
  
    expect(result > 0, true);
  });
  
  test("Metadata SelectAll failed", () async {
    Metadata metadata1 = Metadata(key: "config4", value: "theme:dark,unit:Kg");
    Metadata metadata2 = Metadata(key: "timer", value: "Time:00:00:00.00");
    Metadata metadata3 = Metadata(key: "foo", value: "foo:bar");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertMetadata(metadata1);
    await databaseHelper.insertMetadata(metadata2);
    await databaseHelper.insertMetadata(metadata3);
  
    List<Metadata> entries = await databaseHelper.selectAllMetadata();
    
    expect(entries.contains(metadata1), true);
    expect(entries.contains(metadata2), true);
    expect(entries.contains(metadata3), true);
    expect(entries.length > 3, true);
  });
  
  test("Metadata Select failed", () async {
    Metadata metadata = Metadata(key: "config5", value: "theme:dark,unit:Kg");
    var databaseHelper = DatabaseHelper();
  
    int newId = await databaseHelper.insertMetadata(metadata);
    Metadata? loaded = await databaseHelper.selectMetadata(newId);
  
    expect(loaded, metadata);
  });
  
}

void ReportExerciseDbTest() {
  test("Report Exercise Insertion failed", () async {
    var databaseHelper = DatabaseHelper();
  
    Exercise exercise = Exercise(name: "Rosca direta", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    await databaseHelper.insertExercise(exercise);
  
    Report<Exercise> report = Report(data: "data:data", reportDate: DateTime.now().millisecondsSinceEpoch, object: exercise);
    int newId = await databaseHelper.insertReport(report);
  
    expect(newId > 0, true);
  });
  
  test("Report Exercise Delete failed", () async {
    var databaseHelper = DatabaseHelper();
  
    Exercise exercise = Exercise(name: "Rosca direta", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    await databaseHelper.insertExercise(exercise);
  
    Report<Exercise> report = Report(data: "data:data", reportDate: DateTime.now().millisecondsSinceEpoch, object: exercise);
    await databaseHelper.insertReport(report);
    
    int result = await databaseHelper.deleteReport(report);
    expect(result > 0, true);
  });
  
  test("Report Exercise Update failed", () async {
    var databaseHelper = DatabaseHelper();
  
    Exercise exercise = Exercise(name: "Rosca direta", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    await databaseHelper.insertExercise(exercise);
  
    Report<Exercise> report = Report(data: "data:data", reportDate: DateTime.now().millisecondsSinceEpoch, object: exercise);
    await databaseHelper.insertReport(report);
    
    Report<Exercise> newReport = Report(id: report.id, data: "data:data2", reportDate: report.reportDate, object: report.object);
    int result = await databaseHelper.updateReport(newReport);
  
    expect(result > 0, true);
  });
  
  test("Report Exercise Select failed", () async {
    var databaseHelper = DatabaseHelper();
  
    Exercise exercise1 = Exercise(name: "Rosca direta", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    await databaseHelper.insertExercise(exercise1);
    Report<Exercise> report1 = Report(data: "data:data1", reportDate: DateTime.now().millisecondsSinceEpoch, object: exercise1);
    await databaseHelper.insertReport(report1);
  
    Exercise exercise2 = Exercise(name: "Rosca inclinada", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    await databaseHelper.insertExercise(exercise2);
    Report<Exercise> report2 = Report(data: "data:data2", reportDate: DateTime.now().millisecondsSinceEpoch, object: exercise2);
    await databaseHelper.insertReport(report2);
  
    Exercise exercise3 = Exercise(name: "Rosca inclinada", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    await databaseHelper.insertExercise(exercise3);
    Report<Exercise> report3 = Report(data: "data:data2", reportDate: DateTime.now().millisecondsSinceEpoch, object: exercise3);
    await databaseHelper.insertReport(report3);
  
    List<Report<Exercise>> entries = await databaseHelper.selectAllReport<Exercise>();
  
    expect(entries.contains(report1), true);
    expect(entries.contains(report2), true);
    expect(entries.contains(report3), true);
    expect(entries.length > 3, true);
  });
  
  test("Report Exercise Select failed", () async {
    var databaseHelper = DatabaseHelper();
  
    Exercise exercise = Exercise(name: "Rosca direta", amount: 1, reps: 1, sets: 1, type: ExerciseType.Musclework);
    await databaseHelper.insertExercise(exercise);
  
    Report<Exercise> report = Report(data: "data:data", reportDate: DateTime.now().millisecondsSinceEpoch, object: exercise);
    int newId = await databaseHelper.insertReport(report);
    Report<Exercise>? loaded = await databaseHelper.selectReport<Exercise>(newId);
  
    expect(loaded, report);
  });
}

void ReportTrainingPlanDbTest() {
  test("Report TrainingPlan Insertion failed", () async {
    TrainingPlan plan = TrainingPlan(name: 'Treino A');
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTrainingPlan(plan);
    Report<TrainingPlan> report = Report(data: "foo:bar", reportDate: DateTime.now().millisecondsSinceEpoch, object: plan);
    int newId = await databaseHelper.insertReport(report);
  
    expect(newId > 0, true);
  });
  
  test("Report TrainingPlan Delete failed", () async {
    TrainingPlan plan = TrainingPlan(name: "Treino B");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTrainingPlan(plan);
    Report<TrainingPlan> report = Report(data: "foo:bar", reportDate: DateTime.now().millisecondsSinceEpoch, object: plan);
    await databaseHelper.insertReport(report);
    int result = await databaseHelper.deleteReport(report);
  
    expect(result > 0, true);
  });
  
  test("Report TrainingPlan Update failed", () async {
    TrainingPlan plan = TrainingPlan(name: "Treino H");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTrainingPlan(plan);
    Report<TrainingPlan> report1 = Report(data: "foo:bar", reportDate: DateTime.now().millisecondsSinceEpoch, object: plan);
    await databaseHelper.insertReport(report1);
    Report<TrainingPlan> report2 = Report(id: report1.id, data: "foo:barrrr", reportDate: report1.reportDate, object: report1.object);
    int result = await databaseHelper.updateReport(report2);
  
    expect(result > 0, true);
  });
  
  test("Report TrainingPlan SelectAll failed", () async {
    TrainingPlan plan1 = TrainingPlan(name: "foo");
    TrainingPlan plan2 = TrainingPlan(name: "bar");
    TrainingPlan plan3 = TrainingPlan(name: "foo:bar");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTrainingPlan(plan1);
    await databaseHelper.insertTrainingPlan(plan2);
    await databaseHelper.insertTrainingPlan(plan3);
  
    Report<TrainingPlan> report1 = Report(data: "POWER-V1", reportDate: DateTime.now().millisecondsSinceEpoch, object: plan1);
    Report<TrainingPlan> report2 = Report(data: "POWER-V2", reportDate: DateTime.now().millisecondsSinceEpoch, object: plan2);
    Report<TrainingPlan> report3 = Report(data: "POWER-V3", reportDate: DateTime.now().millisecondsSinceEpoch, object: plan2);
  
    await databaseHelper.insertReport(report1);
    await databaseHelper.insertReport(report2);
    await databaseHelper.insertReport(report3);
    
    List<Report<TrainingPlan>> entries = await databaseHelper.selectAllReport<TrainingPlan>();
    
    expect(entries.contains(report1), true);
    expect(entries.contains(report2), true);
    expect(entries.contains(report3), true);
    expect(entries.length > 3, true);
  });
  
  test("Report TrainingPlan Select failed", () async {
    TrainingPlan plan = TrainingPlan(name: "Treino F");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTrainingPlan(plan);
    Report<TrainingPlan> report1 = Report(data: "Epsilon", reportDate: DateTime.now().millisecondsSinceEpoch, object: plan);
    int newId = await databaseHelper.insertReport(report1);
    Report? loaded = await databaseHelper.selectReport<TrainingPlan>(newId);
  
    expect(loaded, report1);
  });
}

void TagDbTest() {
   test("Tag Insertion failed", () async {
    Tag tag = Tag(name: 'Biceps');
    var databaseHelper = DatabaseHelper();
  
    int newId = await databaseHelper.insertTag(tag);
  
    expect(newId > 0, true);
  });
  
  test("Tag Delete failed", () async {
    Tag tag = Tag(name: "Triceps");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTag(tag);
    int result = await databaseHelper.deleteTag(tag);
  
    expect(result > 0, true);
  });
  
  test("Tag Update failed", () async {
    Tag tag = Tag(name: "Peito");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTag(tag);
    Tag newTag = Tag(id: tag.id, name: "Peitoral");
    int result = await databaseHelper.updateTag(newTag);
  
    expect(result > 0, true);
  });
  
  test("Tag SelectAll failed", () async {
    Tag tag1 = Tag(name: "foo");
    Tag tag2 = Tag(name: "bar");
    Tag tag3 = Tag(name: "foo:bar");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTag(tag1);
    await databaseHelper.insertTag(tag2);
    await databaseHelper.insertTag(tag3);
  
    List<Tag> entries = await databaseHelper.selectAllTag();
  
    expect(entries.contains(tag1), true);
    expect(entries.contains(tag2), true);
    expect(entries.contains(tag3), true);
    expect(entries.length > 3, true);
  });
  
  test("Tag Select failed", () async {
    Tag tag = Tag(name: "Ramon");
    var databaseHelper = DatabaseHelper();
  
    int newId = await databaseHelper.insertTag(tag);
    Tag? loaded = await databaseHelper.selectTag(newId);
  
    expect(loaded, tag);

  });
}

void TrainingPlanDbTest() {
  test("TrainingPlan Insertion failed", () async {
    TrainingPlan plan = TrainingPlan(name: 'Treino A');
    var databaseHelper = DatabaseHelper();
  
    int newId = await databaseHelper.insertTrainingPlan(plan);
  
    expect(newId > 0, true);
  });
  
  test("TrainingPlan Delete failed", () async {
    TrainingPlan plan = TrainingPlan(name: "Treino B");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTrainingPlan(plan);
    int result = await databaseHelper.deleteTrainingPlan(plan);
  
    expect(result > 0, true);
  });
  
  test("TrainingPlan Update failed", () async {
    TrainingPlan plan = TrainingPlan(name: "Treino H");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTrainingPlan(plan);
    TrainingPlan newPlan = TrainingPlan(id: plan.id, name: "Peitoral");
    int result = await databaseHelper.updateTrainingPlan(newPlan);
  
    expect(result > 0, true);
  });
  
  test("TrainingPlan SelectAll failed", () async {
    TrainingPlan plan1 = TrainingPlan(name: "foo");
    TrainingPlan plan2 = TrainingPlan(name: "bar");
    TrainingPlan plan3 = TrainingPlan(name: "foo:bar");
    var databaseHelper = DatabaseHelper();
  
    await databaseHelper.insertTrainingPlan(plan1);
    await databaseHelper.insertTrainingPlan(plan2);
    await databaseHelper.insertTrainingPlan(plan3);
  
    List<TrainingPlan> entries = await databaseHelper.selectAllTrainingPlan();
  
    expect(entries.contains(plan1), true);
    expect(entries.contains(plan2), true);
    expect(entries.contains(plan3), true);
    expect(entries.length > 3, true);
  });
  
  test("TrainingPlan Select failed", () async {
    TrainingPlan plan = TrainingPlan(name: "Treino F");
    var databaseHelper = DatabaseHelper();
  
    int newId = await databaseHelper.insertTrainingPlan(plan);
    TrainingPlan? loaded = await databaseHelper.selectTrainingPlan(newId);
  
    expect(loaded, plan);
  });

  test("TrainingPlan set get plan exercise list failed", () async {
    var databaseHelper = DatabaseHelper();

    TrainingPlan plan = TrainingPlan(name: "Treino F");
    await databaseHelper.insertTrainingPlan(plan);

    List<Exercise> exercises = [];
    Random random = Random();

    for (int i = 0; i < 50; i++) {
      Exercise exercise = Exercise(
        name: "Teste Exercise - $i",
        amount: random.nextInt(20),
        reps: random.nextInt(20),
        sets: random.nextInt(20),
        type: ExerciseType.Musclework,
      );
      exercises.add(exercise);
      await databaseHelper.insertExercise(exercise);

      exercises.shuffle(random);
      await databaseHelper.setPlanExerciseList(plan, exercises);
      List<Exercise> loaded = await databaseHelper.getPlanExerciseList(plan);
      expect(exercises, loaded);
    }

    while(exercises.isNotEmpty) {
      exercises.shuffle(random);
      exercises.removeLast();
      await databaseHelper.setPlanExerciseList(plan, exercises);
      List<Exercise> loaded = await databaseHelper.getPlanExerciseList(plan);
      expect(exercises, loaded);
    }
  });

  test("Exercise set get plan tag list failed", () async {
    var databaseHelper = DatabaseHelper();

    TrainingPlan plan = TrainingPlan(name: "Treino FOO:BAR");
    await databaseHelper.insertTrainingPlan(plan);

    List<Tag> tags = [];

    for(int i = 0; i < 50; i++) {
      Tag tag = Tag(name: "tag:-$i");
      await databaseHelper.insertTag(tag);
      tags.add(tag);

      await databaseHelper.setTagList(plan, tags);
      List<Tag> loaded = await databaseHelper.getTagList(plan);
      expect(loaded, tags);
    }

    while(tags.isNotEmpty) {
      tags.shuffle();
      tags.removeLast();

      await databaseHelper.setTagList(plan, tags);
      List<Tag> loaded = await databaseHelper.getTagList(plan);
      tags.sort((a, b) => (a.id as int).compareTo(b.id as int));
      expect(loaded, tags);
    }
  });
}
