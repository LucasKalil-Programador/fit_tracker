import 'package:fittrackr/app.dart';
import 'package:fittrackr/states/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: Tela de concentimento
// TODO: Tela de exclucao de dados do usuario
// TODO: Termos do usuario/Politicas de privacidade
// TODO: Remover logs com dados sensiveis

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
