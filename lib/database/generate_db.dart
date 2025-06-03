import 'dart:math';

import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/app_states.dart';

void generateDB(ExercisesState exercisesState, TrainingPlanState trainingPlanState, ReportTableState reportTableState, ReportState reportState) {
  _generateExercisesPlans(exercisesState, trainingPlanState);
  _generateReports(reportTableState, reportState);
}

const uuids = [
  "893612ec-4ece-419b-9888-81f0f80942b8", "666ea85f-13c8-48fc-a475-162539bb0978", "07d23e6d-2ba1-4499-8082-41cf96112b64", "94d36af3-a471-42de-8a1b-a41a23ef104a",
  "8b942e26-e5ea-4a02-a6bc-de3062aaf9d0", "414a8b64-b66a-4924-b92e-51429e573a86", "f2e8668a-2b45-4efd-a5da-46e87c30e829", "cbddff8d-2571-466b-87a8-94d4077118fd",
  "53cb1b46-e9ec-4dbc-b5f6-439f1b3a6f02", "3198596a-a01e-47af-aa97-b09bad1143ca", "3f352d45-98b1-4ab9-9749-1ce8cc977cd7", "4aff8c48-5986-4850-af3c-59f2b7e68e19",
  "90461930-4ee4-4583-b5dd-3f5ec55e7d6a", "3e8a9798-28dd-42fb-b215-1284a745593e", "d428132b-a57f-47e1-84ed-e98d287eb5e2", "bd778a92-e37d-4c94-9d97-64d48bf776f9",
  "e7f0859a-7824-4bb1-9868-9ce03f643e26", "e4965340-eb62-480a-bb46-77ddc7b9cf87", "157ccde2-549d-4927-8b4b-996f34febcb5", "ddff26b1-73c4-480f-912b-4e6f674e382d",
  "3e0fc1db-d458-487b-a75c-efcf78db7324", "0b1e097e-9aa3-4241-a987-ef89493b678d", "5e0c03a5-d509-430c-8020-40e02c90425a", "25075da6-6af5-44c2-8192-b3d04309f17f",
  "5bd8a35a-a9b0-4678-b22e-3d7bda3d4cbe", "c6467f59-9ca7-430b-9dfe-31a04f2fead7", "fd6bdfe3-5cf7-4ff0-9d5f-d65b120c0f45", "273402fe-9890-4f63-93bb-2df1460f60ce",
  "9b770a21-1609-463f-b710-636823c13188", "9980cc60-5d1f-4658-bf2e-b04f8749bfa0", "0f3660f1-25e2-46ec-9703-c6528cf41461", "e18e048c-3664-46dd-a737-cc121bac96c6",
  "b41b4103-4c28-49e1-80c7-70257b4adb9c", "c7a4b0ff-0da4-41c9-a190-701703f4930f", "66c5a76e-77e9-434e-8421-7c467896bd91", "a7c76edc-939c-44fc-8b49-87f0f8883dcd",
  "8d4d6125-72a9-4d9f-889a-bf978dd1ab1e", "680ced4a-c7ad-4135-a739-578a84a6bdd9", "98a6000f-ed5c-45d8-ba8e-b0ce87f722a0", "fbaa84d8-3786-4f21-a20c-bbbe279183b0",
  "a463c424-a23f-4361-9682-05296a73b46e", "1b3e92f7-e710-4f87-a544-9fad495381d5", "3442dd7d-48ce-400c-83a0-26f20df19a0c", "393cee6c-54dc-41ba-9c7e-7c77411415e1",
  "2959ed6f-3471-41d2-b9c1-bde537b9242b", "df3afbe7-e1ee-4c55-9b3a-0a5f55cb7c1c", "d0a89e1d-2e2a-49d2-a435-2191ecb58593", "621db664-038b-499d-abe7-70932cf2b90c",
  "430db6a9-5397-41b5-9e81-bee82cd57466", "04a26296-0f6e-4c1c-aa44-e557b6792ace", "f65fa3dd-e0a1-4977-be34-2ee8372b935c", "65e8fe05-0884-4e58-b9df-e5a7d55a491c",
];

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

  for (var i = 0; i < exercises.length; i++) {
    exercises[i].id = uuids[i];
    exercisesState.add(exercises[i]);
  }

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

  final plans = [planA, planB, planC];
  for (var i = 0; i < plans.length; i++) {
    plans[i].id = uuids[i];
    trainingPlanState.add(plans[i]);
  }
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

  final tables = [table1, table2];
  for (var i = 0; i < tables.length; i++) {
    tables[i].id = uuids[i];
    reportTableState.add(tables[i]);
  }

  final now = DateTime.now();
  double peso = 80.0;
  double massaMuscular = 35.0;
  final random = Random();

  for (int i = 0; i < 52; i++) {
    peso += random.nextDouble() * 0.5 - 0.25;
    massaMuscular += random.nextDouble() * 0.3 - 0.1;

    final report = Report(
      id: uuids[i],
      note: "Semana ${i + 1}",
      reportDate: now.subtract(Duration(days: i * 7)).millisecondsSinceEpoch,
      value: double.parse(peso.toStringAsFixed(1)),
      tableId: table1.id!,
    );

    final report2 = Report(
      id: uuids[i],
      note: "Semana ${i + 1}",
      reportDate: now.subtract(Duration(days: i * 7)).millisecondsSinceEpoch,
      value: double.parse(massaMuscular.toStringAsFixed(1)),
      tableId: table2.id!,
    );

    reportState.add(report);
    reportState.add(report2);
  }
}