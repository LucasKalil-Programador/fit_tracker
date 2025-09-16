import 'package:fittrackr/app.dart';
import 'package:fittrackr/states/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const version = "1.0.0";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final states = StateManager();
  await states.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => states.exercisesState),
        ChangeNotifierProvider(create: (_) => states.metadataState),
        ChangeNotifierProvider(create: (_) => states.trainingPlanState),
        ChangeNotifierProvider(create: (_) => states.trainingHistoryState),
        ChangeNotifierProvider(create: (_) => states.reportTableState),
        ChangeNotifierProvider(create: (_) => states.reportState),
        ChangeNotifierProvider(create: (_) => states.authState),
        ChangeNotifierProvider(create: (_) => states),
      ],
      child: App(),
    ),
  );
}
