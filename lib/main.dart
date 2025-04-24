import 'package:fittrackr/Pages/workout_page.dart';
import 'package:fittrackr/entities/exercise.dart';
import 'package:fittrackr/state/exercises_list_state.dart';
import 'package:fittrackr/Pages/exercise_list_page.dart';
import 'package:fittrackr/state/timer_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() {
  ExerciseListState exerciseList = ExerciseListState();
  exerciseList.addExercise(Exercise(name: "Supino reto com barra", load: 60, reps: 10, sets: 4));
  exerciseList.addExercise(Exercise(name: "Supino inclinado com halteres", load: 22, reps: 12, sets: 4));
  exerciseList.addExercise(Exercise(name: "Crossover na polia alta", load: 15, reps: 15, sets: 3));
  exerciseList.addExercise(Exercise(name: "Peck deck", load: 35, reps: 12, sets: 4));
  exerciseList.addExercise(Exercise(name: "Flexão de braço", load: 0, reps: 20, sets: 3));

  exerciseList.addExercise(Exercise(name: "Rosca direta", load: 25, reps: 12, sets: 4));
  exerciseList.addExercise(Exercise(name: "Rosca martelo", load: 20, reps: 12, sets: 3));
  exerciseList.addExercise(Exercise(name: "Rosca alternada com halteres", load: 18, reps: 10, sets: 4));
  exerciseList.addExercise(Exercise(name: "Tríceps pulley", load: 30, reps: 12, sets: 4));
  exerciseList.addExercise(Exercise(name: "Tríceps testa com barra", load: 20, reps: 10, sets: 3));
  exerciseList.addExercise(Exercise(name: "Mergulho entre bancos", load: 0, reps: 15, sets: 3));

  exerciseList.addExercise(Exercise(name: "Agachamento livre", load: 80, reps: 10, sets: 4));
  exerciseList.addExercise(Exercise(name: "Leg press", load: 180, reps: 12, sets: 4));
  exerciseList.addExercise(Exercise(name: "Cadeira extensora", load: 40, reps: 15, sets: 3));
  exerciseList.addExercise(Exercise(name: "Mesa flexora", load: 35, reps: 12, sets: 3));
  exerciseList.addExercise(Exercise(name: "Avanço com halteres", load: 20, reps: 10, sets: 3));
  exerciseList.addExercise(Exercise(name: "Panturrilha em pé", load: 50, reps: 20, sets: 4));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ExerciseListState>(create: (_) => exerciseList),
      ChangeNotifierProvider<TimerState>(create: (_) => TimerState())
    ],
    child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fit Tracker",
      home: MainWidget(),
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF1DCD9F),
          onPrimary: Color(0xFFEFEFEF),
          secondary: Color(0xFF169976),
          onSecondary: Color(0xFFEFEFEF),
          surface: Color(0xFF222222),
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
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
      body: [const Placeholder(), WorkoutPage(), ExerciseListPage(), const Placeholder(), const Placeholder()][currentPageIndex],
    );
  }
}