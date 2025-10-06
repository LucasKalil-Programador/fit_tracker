import 'package:fittrackr/Providers/app/page_index.dart';
import 'package:fittrackr/Controllers/locale/locale_controller.dart';
import 'package:fittrackr/Controllers/theme/theme_controller.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/utils/themes.dart';
import 'package:fittrackr/widgets/Pages/config/config_page.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_list_page.dart';
import 'package:fittrackr/widgets/Pages/home/home_page.dart';
import 'package:fittrackr/widgets/Pages/statistics/statistics_page.dart';
import 'package:fittrackr/widgets/Pages/stop_watch/stop_watch_page.dart';
import 'package:fittrackr/widgets/Pages/workout/workout_page.dart';
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
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final currentPage = ref.watch(pageIndexProvider);
    final pageIndex = ref.read(pageIndexProvider.notifier);
    
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: pageIndex.setPage,
        selectedIndex: currentPage,
        destinations: <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: localization.homeNavBar),
          NavigationDestination(icon: Icon(Icons.alarm), label: localization.timerNavBar),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: localization.trainNavBar),
          NavigationDestination(icon: Icon(Icons.format_list_bulleted), label: localization.exercisesNavBar),
          NavigationDestination(icon: Icon(Icons.insights), label: localization.progressNavBar),
          NavigationDestination(icon: Icon(Icons.settings), label: localization.configNavBar),
        ],
      ),
      body:
          [ HomePage(onChangePage: pageIndex.setPage),
            const StopWatchPage(),
            const WorkoutPage(),
            const ExerciseListPage(),
            const StatisticsPage(),
            const ConfigPage(),
          ][currentPage],
    );
  }
}
