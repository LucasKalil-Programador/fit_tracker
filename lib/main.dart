import 'package:fittrackr/app.dart';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DatabaseProxy.instance;
  
  // instantiates States 
  final trainingPlanState = TrainingPlanState(dbProxy: db.trainingPlan, loadDatabase: true);
  final exercisesState    = ExercisesState   (dbProxy: db.exercise,     loadDatabase: true);
  final metadataState     = MetadataState    (dbProxy: db.metadata,     loadDatabase: true);
  final reportTableState  = ReportTableState (dbProxy: db.reportTable,  loadDatabase: true);
  final reportState       = ReportState      (dbProxy: db.report,       loadDatabase: true);

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

  Future.wait([
    trainingPlanState.waitLoaded(),
    exercisesState.waitLoaded(),
    metadataState.waitLoaded(),
    reportTableState.waitLoaded(),
    reportState.waitLoaded(),
  ]).then((value) => logger.i("All States is Loaded"));
}