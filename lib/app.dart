import 'package:fittrackr/Controllers/locale/locale_controller.dart';
import 'package:fittrackr/Controllers/theme/theme_controller.dart';
import 'package:fittrackr/Providers/common/tab_index.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/utils/themes.dart';
import 'package:fittrackr/widgets/Pages/config/config_page.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_list_page.dart';
import 'package:fittrackr/widgets/Pages/home/home_page.dart';
import 'package:fittrackr/widgets/Pages/statistics/statistics_page.dart';
import 'package:fittrackr/widgets/Pages/stop_watch/stop_watch_page.dart';
import 'package:fittrackr/widgets/Pages/workout/workout_page.dart';
import 'package:fittrackr/widgets_v2/Pages/exercise_list_page_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    
    return MaterialApp(
          title: "Fit Tracker",
          home: MainWidget(),
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: theme,
    );
  }
}

class MainWidget extends ConsumerWidget {
  final String widgetID = "main widget";

  const MainWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final currentPage = ref.watch(tabIndexProvider(id: widgetID));
    final pageIndex = ref.read(tabIndexProvider(id: widgetID).notifier);
    
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: pageIndex.setTab,
        selectedIndex: currentPage,
        destinations: <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: localization.homeNavBar),
          NavigationDestination(icon: Icon(Icons.alarm), label: localization.timerNavBar),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: localization.trainNavBar),
          NavigationDestination(icon: Icon(Icons.format_list_bulleted), label: localization.exercisesNavBar),
          NavigationDestination(icon: Icon(Icons.format_list_bulleted), label: localization.exercisesNavBar),
          NavigationDestination(icon: Icon(Icons.insights), label: localization.progressNavBar),
          NavigationDestination(icon: Icon(Icons.settings), label: localization.configNavBar),
        ],
      ),
      body:
          [ HomePage(onChangePage: pageIndex.setTab),
            const StopWatchPage(),
            const WorkoutPage(),
            const ExerciseListPage(),
            const ExerciseListPageV2(),
            const StatisticsPage(),
            const ConfigPage(),
          ][currentPage],
    );
  }
}
