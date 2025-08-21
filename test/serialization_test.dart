import 'dart:math';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/entities/training_history.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/utils/cloud/serializer.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ExercisesState Serialization test', () async {  
    ExercisesState exercisesState = ExercisesState();
    TrainingPlanState planState = TrainingPlanState();
    TrainingHistoryState historyState = TrainingHistoryState();
    ReportTableState tableState = ReportTableState();
    ReportState reportState = ReportState();

    await _generateStates(exercisesState, planState, historyState, tableState, reportState); 

    final resultSer = Serializer.serialize([exercisesState, planState, historyState, tableState, reportState]);
    final resultDer = Serializer.deserialize(resultSer.compressed);

    expect(resultSer.json.hashCode, resultDer.jsonRaw.hashCode);
    expect(resultDer.exercises?.length, exercisesState.clone.length);
    expect(listEquals(resultDer.exercises, exercisesState.clone), true);
  });

  test('Training Plan Serialization test', () async {  
    ExercisesState exercisesState = ExercisesState();
    TrainingPlanState planState = TrainingPlanState();
    TrainingHistoryState historyState = TrainingHistoryState();
    ReportTableState tableState = ReportTableState();
    ReportState reportState = ReportState();

    await _generateStates(exercisesState, planState, historyState, tableState, reportState);

    final resultSer = Serializer.serialize([exercisesState, planState, historyState, tableState, reportState]);
    final resultDer = Serializer.deserialize(resultSer.compressed);
    
    expect(resultSer.json.hashCode, resultDer.jsonRaw.hashCode);
    expect(resultDer.plans?.length, planState.clone.length);
    expect(listEquals(resultDer.plans, planState.clone), true);
  });

  test('Training History Serialization test', () async {  
    ExercisesState exercisesState = ExercisesState();
    TrainingPlanState planState = TrainingPlanState();
    TrainingHistoryState historyState = TrainingHistoryState();
    ReportTableState tableState = ReportTableState();
    ReportState reportState = ReportState();

    await _generateStates(exercisesState, planState, historyState, tableState, reportState);

    final resultSer = Serializer.serialize([exercisesState, planState, historyState, tableState, reportState]);
    final resultDer = Serializer.deserialize(resultSer.compressed);
    
    expect(resultSer.json.hashCode, resultDer.jsonRaw.hashCode);
    expect(resultDer.history?.length, historyState.clone.length);
    expect(listEquals(resultDer.history, historyState.clone), true);
  });

  test('Report Table Serialization test', () async {  
    ExercisesState exercisesState = ExercisesState();
    TrainingPlanState planState = TrainingPlanState();
    TrainingHistoryState historyState = TrainingHistoryState();
    ReportTableState tableState = ReportTableState();
    ReportState reportState = ReportState();

    await _generateStates(exercisesState, planState, historyState, tableState, reportState);

    final resultSer = Serializer.serialize([exercisesState, planState, historyState, tableState, reportState]);
    final resultDer = Serializer.deserialize(resultSer.compressed);
    
    expect(resultSer.json.hashCode, resultDer.jsonRaw.hashCode);
    expect(resultDer.tables?.length, tableState.clone.length);
    expect(listEquals(resultDer.tables, tableState.clone), true);
  });

  test('Report Serialization test', () async {  
    ExercisesState exercisesState = ExercisesState();
    TrainingPlanState planState = TrainingPlanState();
    TrainingHistoryState historyState = TrainingHistoryState();
    ReportTableState tableState = ReportTableState();
    ReportState reportState = ReportState();

    await _generateStates(exercisesState, planState, historyState, tableState, reportState);

    final resultSer = Serializer.serialize([exercisesState, planState, historyState, tableState, reportState]);
    final resultDer = Serializer.deserialize(resultSer.compressed);
    
    expect(resultSer.json.hashCode, resultDer.jsonRaw.hashCode);
    expect(resultDer.reports?.length, reportState.clone.length);
    expect(listEquals(resultDer.reports, reportState.clone), true);
  });

  test('Big Serialization test', () async {  
    ExercisesState exercisesState = ExercisesState();
    TrainingPlanState planState = TrainingPlanState();
    TrainingHistoryState historyState = TrainingHistoryState();
    ReportTableState tableState = ReportTableState();
    ReportState reportState = ReportState();

    await _generateStates(exercisesState, planState, historyState, tableState, reportState, 250);

    final resultSer = Serializer.serialize([exercisesState, planState, historyState, tableState, reportState]);
    
    final jsonLen = resultSer.json.length;
    final compressedLen = resultSer.compressed.length;
    logger.i("Json Length: $jsonLen, Compressed Length: $compressedLen, Ratio: ${jsonLen / compressedLen}");

    final resultDer = Serializer.deserialize(resultSer.compressed);

    expect(resultSer.json.hashCode, resultDer.jsonRaw.hashCode);

    expect(resultDer.exercises?.length, exercisesState.clone.length);
    expect(resultDer.plans?.length, planState.clone.length);
    expect(resultDer.history?.length, historyState.clone.length);
    expect(resultDer.tables?.length, tableState.clone.length);
    expect(resultDer.reports?.length, reportState.clone.length);

    expect(listEquals(resultDer.exercises, exercisesState.clone), true);
    expect(listEquals(resultDer.plans, planState.clone), true);
    expect(listEquals(resultDer.history, historyState.clone), true);
    expect(listEquals(resultDer.tables, tableState.clone), true);
    expect(listEquals(resultDer.reports, reportState.clone), true);
  });
}

Future<void> _generateStates(
  ExercisesState exercisesState,
  TrainingPlanState planState,
  TrainingHistoryState historyState,
  ReportTableState tableState,
  ReportState reportState,
  [int length = 20]
) async {
   for (var i = 0; i < length; i++) {
    Exercise exercise = Exercise(name: "Exercise-$i", amount: i * 2, reps: i * 3, sets: i * 4, type: i % 2 == 0 ? ExerciseType.cardio : ExerciseType.musclework);
    await exercisesState.addWait(exercise);
  }
  
  for (var i = 0; i < length; i++) {
    final exercises = exercisesState.clone..shuffle(Random());
    TrainingPlan plan = TrainingPlan(name: "TrainingPlan-$i", list: exercises.take(i).map((e) => e.id!).toList());
    await planState.addWait(plan);
  }
  
  for (var i = 0; i < length; i++) {
    final exercises = exercisesState.clone..shuffle(Random());
    final plans = planState.clone..shuffle(Random());
    TrainingHistory history = TrainingHistory.fromTrainingPlan(plan: plans.first, exercises: exercises.take(i).toList(), dateTime: DateTime.now().millisecondsSinceEpoch + i);
    await historyState.addWait(history);
  }
  
  for (var i = 0; i < length; i++) {
    ReportTable table = ReportTable(
      name: "Table-$i",
      description: "Description-$i",
      valueSuffix: "$i km",
      createdAt: DateTime.now().millisecondsSinceEpoch + i,
      updatedAt: DateTime.now().millisecondsSinceEpoch + i * i,
    );
    await tableState.addWait(table);
  }
  
  for (var i = 0; i < length; i++) {
    final table = tableState.clone..shuffle(Random());
    Report report = Report(note: "Note-$i", reportDate: DateTime.now().millisecondsSinceEpoch + i, value: (i * i).toDouble(), tableId: table.first.id!);
    await reportState.addWait(report);
  }
}