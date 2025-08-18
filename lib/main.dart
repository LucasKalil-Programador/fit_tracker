import 'package:firebase_core/firebase_core.dart';
import 'package:fittrackr/app.dart';
import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/firebase_options.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/auth_state.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseInitialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final states = _StateManager();

  await Future.wait(
    [firebaseInitialization, states.initialize()]
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => states.exercisesState),
        ChangeNotifierProvider(create: (_) => states.metadataState),
        ChangeNotifierProvider(create: (_) => states.trainingPlanState),
        ChangeNotifierProvider(create: (_) => states.trainingHistoryState),
        ChangeNotifierProvider(create: (_) => states.reportTableState),
        ChangeNotifierProvider(create: (_) => states.reportState),
        ChangeNotifierProvider(create: (_) => AuthState(), lazy: false,)
      ],
      child: App(),
    ),
  );
}
class _StateManager {
  late final ExercisesState exercisesState;
  late final MetadataState metadataState;
  late final TrainingPlanState trainingPlanState;
  late final TrainingHistoryState trainingHistoryState;
  late final ReportTableState reportTableState;
  late final ReportState reportState;

  Future<void> initialize() async {
    final db = DatabaseProxy.instance;
    exercisesState = ExercisesState(dbProxy: db.exercise, loadDatabase: true);
    metadataState = MetadataState(dbProxy: db.metadata, loadDatabase: true);
    trainingPlanState = TrainingPlanState(dbProxy: db.trainingPlan, loadDatabase: true);
    trainingHistoryState = TrainingHistoryState(dbProxy: db.trainingHistory, loadDatabase: true);
    reportTableState = ReportTableState(dbProxy: db.reportTable, loadDatabase: true);
    reportState = ReportState(dbProxy: db.report, loadDatabase: true);

    await Future.wait([
      exercisesState.waitLoaded(),
      metadataState.waitLoaded(),
      trainingPlanState.waitLoaded(),
      trainingHistoryState.waitLoaded(),
      reportTableState.waitLoaded(),
      reportState.waitLoaded(),
    ]);
  }
}