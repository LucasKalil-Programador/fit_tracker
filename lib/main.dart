import 'package:fittrackr/app.dart';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DatabaseProxy.instance;
  
  // instantiates States 
  final trainingPlanState = TrainingPlanState(db.trainingPlan);
  final exercisesState    = ExercisesState(db.exercise);
  final metadataState     = MetadataState();
  final reportTableState  = ReportTableState(null);
  final reportState       = ReportState(null);
  
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