import 'package:fittrackr/app.dart';
import 'package:fittrackr/database/save_load_utils/generate_db.dart';
import 'package:fittrackr/database/save_load_utils/load_utils.dart';
import 'package:fittrackr/database/save_load_utils/save_utils.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // instantiates States 
  final trainingPlanState = TrainingPlanState();
  final exercisesState    = ExercisesState();
  final metadataState     = MetadataState();
  final reportTableState  = ReportTableState();
  final reportState       = ReportState();

  // Try load each database and setup saver callback
  await loadDatabase(metadataState, exercisesState, trainingPlanState, reportTableState, reportState);

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

Future<void> loadDatabase(
  MetadataState metadataState,
  ExercisesState exercisesState,
  TrainingPlanState trainingPlanState,
  ReportTableState reportTableState,
  ReportState reportState) async {
  late DateTime start;
  if(kDebugMode) start = DateTime.now();
  
  final loadtask1 = loadMetadata().then(metadataState.setMap);
  final loadtask2 = loadExercises().then(exercisesState.setList);
  final loadtask3 = loadTrainingPlans().then(trainingPlanState.setList);
  await Future.wait([loadtask1, loadtask2, loadtask3])
    .then((value) {
      // setup call backs to save data in database
      setupSaver(metadataState, exercisesState, trainingPlanState); 

      // if database is empty generate a sample data
      if(exercisesState.isEmpty && trainingPlanState.isEmpty) {
        generateExercisesPlans(exercisesState, trainingPlanState);
      }
      if(reportTableState.isEmpty && reportState.isEmpty) {
        generateReports(reportTableState, reportState);
      }
    });

  if(kDebugMode) {
    final elapsed = DateTime.now().difference(start);
    print("Load took: $elapsed");
  }
}

void setupSaver(MetadataState metadataState, ExercisesState exercisesState, TrainingPlanState trainingPlanState) {
  final debounceSaver = DebounceRunner(
    delay: Duration(seconds: 1),
    callback: () async {
      final task1 = saveMetadata(metadataState.clone());
      final task2 = saveExercise(exercisesState.flushUpdatePatch());
      final task3 = saveTrainingPlan(trainingPlanState.flushUpdatePatch());
      await Future.wait([task1, task2, task3]);
    }
  );
  
  metadataState.addListener(debounceSaver.runAfter);
  exercisesState.addListener(debounceSaver.runAfter);
  trainingPlanState.addListener(debounceSaver.runAfter);
}
