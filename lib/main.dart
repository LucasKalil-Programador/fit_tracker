import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/database/debounce_save.dart';
import 'package:fittrackr/database/generate_db.dart';
import 'package:fittrackr/database/load_utils.dart';
import 'package:fittrackr/my_app.dart';
import 'package:fittrackr/states/exercises_state.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/database/save_utils.dart';
import 'package:fittrackr/states/training_plan_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // instantiates States 
  TrainingPlanState trainingPlanState = TrainingPlanState();
  ExercisesState exercisesState = ExercisesState();
  MetadataState metadataState = MetadataState();

  // Try load each database
  await loadDatabase(metadataState, exercisesState, trainingPlanState)
    .then((value) {
      // setup call backs to save data in database
      setupSaver(metadataState, exercisesState, trainingPlanState); 

      // if database is empty generate a simple data
      if(exercisesState.isEmpty && trainingPlanState.isEmpty) 
        generateDB(exercisesState, trainingPlanState);
    });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ExercisesState>(create: (_) => exercisesState),
        ChangeNotifierProvider<MetadataState>(create: (_) => metadataState),
        ChangeNotifierProvider<TrainingPlanState>(create: (_) => trainingPlanState)
        ],
      child: MyApp(),
    ),
  );
}

Future<void> loadDatabase(MetadataState metadataState, ExercisesState exercisesState, TrainingPlanState trainingPlanState) async {
  final loadtask1 = loadMetadata().then(metadataState.setMap);
  final loadtask2 = loadExercises().then(exercisesState.setList);
  final loadtask3 = loadTrainingPlans().then(trainingPlanState.setList);
  await Future.wait([loadtask1, loadtask2, loadtask3]);
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
