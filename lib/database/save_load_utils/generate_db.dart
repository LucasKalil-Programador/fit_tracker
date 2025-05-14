import 'dart:math';

import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/app_states.dart';

void generateExercisesPlans(ExercisesState exercisesState, TrainingPlanState trainingPlanState) {
  List<Exercise> exercises = [];
  exercises.add(Exercise(name: "Supino reto", amount: 40, reps: 10, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Agachamento livre", amount: 60, reps: 12, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Remada curvada", amount: 35, reps: 10, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Desenvolvimento com halteres", amount: 20, reps: 12, sets: 3, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Leg press", amount: 100, reps: 15, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Puxada frente", amount: 45, reps: 12, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Rosca direta", amount: 30, reps: 15, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Tríceps testa", amount: 25, reps: 12, sets: 3, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Crucifixo reto", amount: 15, reps: 12, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Cadeira extensora", amount: 50, reps: 15, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Mesa flexora", amount: 40, reps: 12, sets: 3, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Panturrilha no leg press", amount: 80, reps: 20, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Elevação lateral", amount: 10, reps: 15, sets: 3, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Rosca alternada", amount: 12, reps: 12, sets: 4, type: ExerciseType.musclework));
  exercises.add(Exercise(name: "Tríceps pulley", amount: 35, reps: 15, sets: 4, type: ExerciseType.musclework));
  
  exercises.add(Exercise(name: "Corrida na esteira", amount: 30, reps: 1, sets: 1, type: ExerciseType.cardio));
  exercises.add(Exercise(name: "Bicicleta ergométrica", amount: 25, reps: 1, sets: 1, type: ExerciseType.cardio));
  exercises.add(Exercise(name: "Escada ergométrica", amount: 20, reps: 1, sets: 1, type: ExerciseType.cardio));

  exercisesState.addAll(exercises); 
  TrainingPlan plan1 = TrainingPlan(name: "Treino A", list: exercises.take(5).map((e) => e.id!).toList());
  TrainingPlan plan2 = TrainingPlan(name: "Treino B", list: exercises.take(6).map((e) => e.id!).toList());
  TrainingPlan plan3 = TrainingPlan(name: "Treino C", list: exercises.take(4).map((e) => e.id!).toList());
  trainingPlanState.addAll([plan1, plan2, plan3]);
}

void generateReports(ReportTableState reportTableState, ReportState reportState) {
  final table1 = ReportTable(
    name: "Pesagem Semanal",
    description: "Registro de peso corporal semanal",
    valueSuffix: "Kg",
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
  );

  final table2 = ReportTable(
    name: "Massa Muscular",
    description: "Estimativa da massa muscular ao longo do tempo",
    valueSuffix: "Kg",
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
  );

  reportTableState.add(table1);
  reportTableState.add(table2);

  final now = DateTime.now();
  double peso = 80.0;
  double massaMuscular = 35.0;
  final random = Random();

  for (int i = 0; i < 52; i++) {
    peso += random.nextDouble() * 0.5 - 0.25;
    massaMuscular += random.nextDouble() * 0.3 - 0.1;

    final report = Report(
      note: "Semana ${i + 1}",
      reportDate: now.subtract(Duration(days: i * 7)).millisecondsSinceEpoch,
      value: double.parse(peso.toStringAsFixed(1)),
      tableId: table1.id!,
    );

    final report2 = Report(
      note: "Semana ${i + 1}",
      reportDate: now.subtract(Duration(days: i * 7)).millisecondsSinceEpoch,
      value: double.parse(massaMuscular.toStringAsFixed(1)),
      tableId: table2.id!,
    );

    reportState.add(report);
    reportState.add(report2);
  }
}