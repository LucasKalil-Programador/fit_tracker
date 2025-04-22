import 'package:fittrackr/exercise_form.dart';
import 'package:fittrackr/timer_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Fit Tracker", home: MainWidget());
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
      body: [Placeholder(), TimerWidget(), ExerciseForm(), Placeholder(), Placeholder()][currentPageIndex],
    );
  }
}
