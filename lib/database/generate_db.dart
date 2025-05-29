import 'dart:math';

import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/app_states.dart';

void generateDB(ExercisesState exercisesState, TrainingPlanState trainingPlanState, ReportTableState reportTableState, ReportState reportState) {
  _generateExercisesPlans(exercisesState, trainingPlanState);
  _generateReports(reportTableState, reportState);
}

void _generateExercisesPlans(ExercisesState exercisesState, TrainingPlanState trainingPlanState) {
  final List<Exercise> exercises = [
    // Peito, tríceps e ombro
    Exercise(name: "Supino reto", amount: 50, reps: 10, sets: 4, type: ExerciseType.musclework),
    Exercise(name: "Crucifixo reto", amount: 15, reps: 12, sets: 3, type: ExerciseType.musclework),
    Exercise(name: "Tríceps testa", amount: 25, reps: 12, sets: 3, type: ExerciseType.musclework),
    Exercise(name: "Tríceps pulley", amount: 35, reps: 15, sets: 3, type: ExerciseType.musclework),
    Exercise(name: "Desenvolvimento com halteres", amount: 22, reps: 10, sets: 3, type: ExerciseType.musclework),
    Exercise(name: "Elevação lateral", amount: 10, reps: 15, sets: 3, type: ExerciseType.musclework),

    // Costas e bíceps
    Exercise(name: "Remada curvada", amount: 40, reps: 10, sets: 4, type: ExerciseType.musclework),
    Exercise(name: "Puxada frente", amount: 50, reps: 12, sets: 4, type: ExerciseType.musclework),
    Exercise(name: "Rosca direta", amount: 30, reps: 12, sets: 3, type: ExerciseType.musclework),
    Exercise(name: "Rosca alternada", amount: 15, reps: 12, sets: 3, type: ExerciseType.musclework),

    // Pernas
    Exercise(name: "Agachamento livre", amount: 70, reps: 10, sets: 4, type: ExerciseType.musclework),
    Exercise(name: "Leg press", amount: 120, reps: 12, sets: 4, type: ExerciseType.musclework),
    Exercise(name: "Cadeira extensora", amount: 50, reps: 15, sets: 3, type: ExerciseType.musclework),
    Exercise(name: "Mesa flexora", amount: 40, reps: 12, sets: 3, type: ExerciseType.musclework),
    Exercise(name: "Panturrilha no leg press", amount: 80, reps: 20, sets: 4, type: ExerciseType.musclework),

    // Cardio
    Exercise(name: "Corrida na esteira", amount: 30, reps: 1, sets: 1, type: ExerciseType.cardio),
    Exercise(name: "Bicicleta ergométrica", amount: 25, reps: 1, sets: 1, type: ExerciseType.cardio),
    Exercise(name: "Escada ergométrica", amount: 20, reps: 1, sets: 1, type: ExerciseType.cardio),
  ];

  exercisesState.addAll(exercises);

  // Planejamento ABC por grupo muscular
  final planA = TrainingPlan(
    name: "Treino A - Peito/Tríceps/Ombro",
    list: exercises.where((e) => [
      "Supino reto", "Crucifixo reto", "Tríceps testa", "Tríceps pulley", "Desenvolvimento com halteres", "Elevação lateral"
    ].contains(e.name)).map((e) => e.id!).toList(),
  );

  final planB = TrainingPlan(
    name: "Treino B - Costas/Bíceps",
    list: exercises.where((e) => [
      "Remada curvada", "Puxada frente", "Rosca direta", "Rosca alternada"
    ].contains(e.name)).map((e) => e.id!).toList(),
  );

  final planC = TrainingPlan(
    name: "Treino C - Pernas",
    list: exercises.where((e) => [
      "Agachamento livre", "Leg press", "Cadeira extensora", "Mesa flexora", "Panturrilha no leg press"
    ].contains(e.name)).map((e) => e.id!).toList(),
  );

  trainingPlanState.addAll([planA, planB, planC]);
}

void _generateReports(ReportTableState reportTableState, ReportState reportState) {
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