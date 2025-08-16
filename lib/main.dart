import 'package:firebase_core/firebase_core.dart';
import 'package:fittrackr/app.dart';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/firebase_options.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final db = DatabaseProxy.instance;
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExercisesState      (dbProxy: db.exercise,        loadDatabase: true)),
        ChangeNotifierProvider(create: (_) => MetadataState       (dbProxy: db.metadata,        loadDatabase: true)),
        ChangeNotifierProvider(create: (_) => TrainingPlanState   (dbProxy: db.trainingPlan,    loadDatabase: true)),
        ChangeNotifierProvider(create: (_) => TrainingHistoryState(dbProxy: db.trainingHistory, loadDatabase: true)),
        ChangeNotifierProvider(create: (_) => ReportTableState    (dbProxy: db.reportTable,     loadDatabase: true)),
        ChangeNotifierProvider(create: (_) => ReportState         (dbProxy: db.report,          loadDatabase: true)),
      ],
      child: App(),
    ),
  );
}