import 'package:fittrackr/states/exercises_state.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/states/training_plan_state.dart';
import 'package:fittrackr/widgets/Pages/exercise_list_page.dart';
import 'package:fittrackr/widgets/Pages/workout_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  TrainingPlanState trainingPlanState = TrainingPlanState();
  ExercisesState exercisesState = ExercisesState();
  MetadataState metadataState = MetadataState();
  await trainingPlanState.loadDatabase();
  await exercisesState.loadDatabase();
  await metadataState.loadDatabase();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ExercisesState>(create: (_) => exercisesState),
        ChangeNotifierProvider<MetadataState>(create: (_) => metadataState),
        ChangeNotifierProvider<TrainingPlanState>(create: (_) => trainingPlanState)
        ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ColorScheme customDarkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFBCC3FF),
    onPrimary: Color(0xFF242C61),
    primaryContainer: Color(0xFF3B4279),
    onPrimaryContainer: Color(0xFFDFE0FF),
    secondary: Color(0xFFC4C5DD),
    onSecondary: Color(0xFF2D2F42),
    secondaryContainer: Color(0xFF434559),
    onSecondaryContainer: Color(0xFFE0E1F9),
    tertiary: Color(0xFFE6BAD7),
    onTertiary: Color(0xFF45263D),
    tertiaryContainer: Color(0xFF5D3C54),
    onTertiaryContainer: Color(0xFFFFD7F0),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF131318),
    onSurface: Color(0xFFE4E1E9),
    onSurfaceVariant: Color(0xFFC7C5D0),
    outline: Color(0xFF90909A),
    inverseSurface: Color(0xFFE4E1E9),
    onInverseSurface: Color(0xFF303036),
    inversePrimary: Color(0xFF535A92),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFBCC3FF),
  );

  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      useMaterial3: true,
      colorScheme: customDarkColorScheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: customDarkColorScheme.primaryContainer,
          foregroundColor: customDarkColorScheme.onPrimaryContainer,
          shadowColor: customDarkColorScheme.shadow,
          elevation: 2,
        ),
      ),
    );

    return MaterialApp(
      title: "Fit Tracker",
      home: MainWidget(),
      theme: theme,
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
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
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Treinar'),
          NavigationDestination(icon: Icon(Icons.format_list_bulleted), label: 'Exercícios'),
          NavigationDestination(icon: Icon(Icons.insights), label: "Progresso"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Config")
        ],
      ),
      body: [const Placeholder(), const WorkoutPage(), const ExerciseListPage(), const Placeholder(), const Placeholder()][currentPageIndex],
    );
  }
}