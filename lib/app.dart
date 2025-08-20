import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/utils/themes.dart';
import 'package:fittrackr/widgets/Pages/config/config_page.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_list_page.dart';
import 'package:fittrackr/widgets/Pages/home/home_page.dart';
import 'package:fittrackr/widgets/Pages/statistics/statistics_page.dart';
import 'package:fittrackr/widgets/Pages/stop_watch/stop_watch_page.dart';
import 'package:fittrackr/widgets/Pages/workout/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector2<MetadataState, MetadataState, Tuple2<String?, String?>>(
      selector: (_, _, metadataState) => Tuple2(metadataState.get(themeKey), metadataState.get(localeKey)),
      builder: (context, configTuple, child) {
        return MaterialApp(
          title: "Fit Tracker",
          home: MainWidget(),
          locale: resolveLocale(configTuple.item2, context),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: resolveTheme(configTuple.item1),
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

  Locale? resolveLocale(String? localeCode, BuildContext context) {
    Locale? locale;
    switch (localeCode) {
      case "en":
        locale = Locale("en");
        break;
      case "pt":
        locale = Locale("pt");
        break;
      case "sys":
        locale = null;
        break;
      default: 
        locale = null;
    }
    return locale;
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late final AppLocalizations localization;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: onDestinationSelected,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: localization.homeNavBar),
          NavigationDestination(icon: Icon(Icons.alarm), label: localization.timerNavBar),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: localization.trainNavBar),
          NavigationDestination(icon: Icon(Icons.format_list_bulleted), label: localization.exercisesNavBar),
          NavigationDestination(icon: Icon(Icons.insights), label: localization.progressNavBar),
          NavigationDestination(icon: Icon(Icons.settings), label: localization.configNavBar)
        ],
      ),
      body:
          [ HomePage(onChangePage: onDestinationSelected),
            const StopWatchPage(),
            const WorkoutPage(),
            const ExerciseListPage(),
            const StatisticsPage(),
            const ConfigPage(),
          ][currentPageIndex],
    );
  }

  void onDestinationSelected(int value) {
    setState(() {
      currentPageIndex = value;
    });
  }
}