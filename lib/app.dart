import 'dart:async';
import 'dart:io';

import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/utils/importer_exporter.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:fittrackr/utils/themes.dart';
import 'package:fittrackr/widgets/Pages/config/config_page.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_list_page.dart';
import 'package:fittrackr/widgets/Pages/home/home_page.dart';
import 'package:fittrackr/widgets/Pages/statistics/statistics_page.dart';
import 'package:fittrackr/widgets/Pages/stop_watch/stop_watch_page.dart';
import 'package:fittrackr/widgets/Pages/workout/workout_page.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MetadataState, String?>(
      selector: (_, metadataState) => metadataState.get(themeKey),
      builder: (context, selectedTheme, child) {
        return MaterialApp(
          title: "Fit Tracker",
          home: MainWidget(),
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: resolveTheme(selectedTheme),
        );
      },
    );
  }
  
  ThemeMode resolveTheme(String? theme) {
    ThemeMode themeMode;
    switch (theme) {
      case "dark":
        themeMode = ThemeMode.dark;
        break;
      case "light":
        themeMode = ThemeMode.light;
        break;
      case "system": 
        themeMode = ThemeMode.system;
        break;
      default:
        themeMode = ThemeMode.system;
    }
    return themeMode;
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  StreamSubscription? streamSubscription;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            currentPageIndex = value;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.alarm), label: 'Timer'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Treinar'),
          NavigationDestination(icon: Icon(Icons.format_list_bulleted), label: 'Exercícios'),
          NavigationDestination(icon: Icon(Icons.insights), label: "Progresso"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Config")
        ],
      ),
      body:
          [ const HomePage(),
            const StopWatchPage(),
            const WorkoutPage(),
            const ExerciseListPage(),
            const StatisticsPage(),
            const ConfigPage(),
          ][currentPageIndex],
    );
  }

  @override
  void initState() {
    super.initState();

    streamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen(onReceiveEvent);
    ReceiveSharingIntent.instance.getInitialMedia().then(onReceiveEvent);
  }

  @override
  void dispose() {
    super.dispose();

    streamSubscription?.cancel();
  }

  void onReceiveEvent(List<SharedMediaFile> events) async {
    logger.i("Recebido input {$events}");
    try {
      if (events.isEmpty) return;
      final event = events.first;

      if (event.type == SharedMediaType.file && event.path.endsWith(".json")) {
        final file = File(event.path);
        final data = await file.readAsString();
        if (mounted) {
          final importedData = jsonToData(data);
          await confirmAction(context, importedData);
        }
      }
    } catch (e) {
      if(mounted) {
        showSnackMessage(context, "Erro ao tentar importar dados", false);
      }
      logger.w(e);
    }
  }

  Future<void> confirmAction(BuildContext context, Data importedData) async {
    final task = await showDialog<int>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Importar dados"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'Dados carregados com sucesso!\n\n'
                    'Total de dados:\n'
                    '• Exercícios: ${(importedData.exercises ?? []).length}\n'
                    '• Planos: ${(importedData.plans ?? []).length}\n'
                    '• Tabelas: ${(importedData.tables ?? []).length}\n'
                    '• Relatórios: ${(importedData.reports ?? []).length}',
                  ),
                ),
                ElevatedButton(
                  child: Text("Importar substituir"),
                  onPressed: () => Navigator.pop(context, 0),
                ),
                ElevatedButton(
                  child: Text("Importar adicionar"),
                  onPressed: () => Navigator.pop(context, 1),
                ),
                ElevatedButton(
                  child: Text("Cancelar"),
                  onPressed: () => Navigator.pop(context, 2),
                )
              ],
            ),
          ),
    );
    
    switch (task) {
      case 0:
        if(context.mounted) {
          await dataToContext(importedData, context, true);
        }
        break;
      case 1:
        if(context.mounted) {
          await dataToContext(importedData, context, false);
        }
        break;
      default:
    }
  }
}