import 'dart:math';

import 'package:fittrackr/database/debounce_save.dart';
import 'package:fittrackr/database/entities/report.dart';
import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/generate_db.dart';
import 'package:fittrackr/database/load_utils.dart';
import 'package:fittrackr/app.dart';
import 'package:fittrackr/states/exercises_state.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/database/save_utils.dart';
import 'package:fittrackr/states/report_state.dart';
import 'package:fittrackr/states/report_table_state.dart';
import 'package:fittrackr/states/training_plan_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // instantiates States 
  final trainingPlanState = TrainingPlanState();
  final exercisesState    = ExercisesState();
  final metadataState     = MetadataState();
  final reportTableState  = ReportTableState();
  final reportState       = ReportState();

  // Try load each database and setup saver callback
  await loadDatabase(metadataState, exercisesState, trainingPlanState);

  final table = ReportTable(
    name: "Pesagem",
    description: "Tabele de pesagem seco",
    valueSuffix: "Kg",
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
  );

  Random random = Random();
  reportTableState.add(table);
  for (int i = 0; i < 365; i++) {
    final report = Report(
      note: "Note: $i",
      reportDate: DateTime.now().subtract(Duration(days: i)).millisecondsSinceEpoch,
      value: 110 + random.nextDouble() * 10,
      tableId: table.id!,
    );
    reportState.add(report);
  } 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => exercisesState),
        ChangeNotifierProvider(create: (_) => metadataState),
        ChangeNotifierProvider(create: (_) => trainingPlanState),
        ChangeNotifierProvider(create: (_) => reportTableState),
        ChangeNotifierProvider(create: (_) => reportState),
      ],
      child: App(),
    ),
  );
}

Future<void> loadDatabase(MetadataState metadataState, ExercisesState exercisesState, TrainingPlanState trainingPlanState, [bool debug = false]) async {
  late DateTime start;
  if(debug) start = DateTime.now();
  
  final loadtask1 = loadMetadata(debug).then(metadataState.setMap);
  final loadtask2 = loadExercises(debug).then(exercisesState.setList);
  final loadtask3 = loadTrainingPlans(debug).then(trainingPlanState.setList);
  await Future.wait([loadtask1, loadtask2, loadtask3])
    .then((value) {
      // setup call backs to save data in database
      setupSaver(metadataState, exercisesState, trainingPlanState); 

      // if database is empty generate a simple data
      if(exercisesState.isEmpty && trainingPlanState.isEmpty) 
        generateDB(exercisesState, trainingPlanState);
    });

  if(debug) {
    final elapsed = DateTime.now().difference(start);
    print("Load took: $elapsed");
  }
}

void setupSaver(MetadataState metadataState, ExercisesState exercisesState, TrainingPlanState trainingPlanState) {
  final metadataSaver = DebounceRunner<void>(
    delay: Duration(seconds: 1),
    callback: (e) => saveMetadata(metadataState.clone()),
  );
  
  final exerciseSaver = DebounceRunner<void>(
    delay: Duration(seconds: 1),
    callback: (e) => saveExercise(exercisesState.flushUpdatePatch()),
  );
  
  final trainingPlanSaver = DebounceRunner<void>(
    delay: Duration(seconds: 1),
    callback: (e) => saveTrainingPlan(trainingPlanState.flushUpdatePatch()),
  );
  
  metadataState.addListener(() => metadataSaver.runAfter(null));
  exercisesState.addListener(() => exerciseSaver.runAfter(null));
  trainingPlanState.addListener(() => trainingPlanSaver.runAfter(null));
}
