import 'dart:math';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/app_states.dart';

Future<void> generateDB(ExercisesState exercisesState, TrainingPlanState trainingPlanState, ReportTableState reportTableState, ReportState reportState) async {
  final task1 = _generateExercisesPlans(exercisesState, trainingPlanState);
  final task2 = _generateReports(reportTableState, reportState);
  await Future.wait([task1, task2]);
}

Future<void> _generateExercisesPlans(ExercisesState exercisesState, TrainingPlanState trainingPlanState) async {
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
  }
  await exercisesState.addAll(exercises);

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
  }
  await trainingPlanState.addAll(plans);
}

Future<void> _generateReports(ReportTableState reportTableState, ReportState reportState) async {
  final table1 = ReportTable(
    id: uuids[0],
    name: "Pesagem Semanal",
    description: "Registro de peso corporal semanal",
    valueSuffix: "Kg",
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
  );

  final table2 = ReportTable(
    id: uuids[1],
    name: "Massa Muscular",
    description: "Estimativa da massa muscular ao longo do tempo",
    valueSuffix: "Kg",
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
  );

  await reportTableState.addAll([table1, table2]);

  final now = DateTime.now();
  double peso = 80.0;
  double massaMuscular = 35.0;
  final random = Random();

  List<Report> reports = [];
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
      id: uuids[52 + i],
      note: "Semana ${i + 1}",
      reportDate: now.subtract(Duration(days: i * 7)).millisecondsSinceEpoch,
      value: double.parse(massaMuscular.toStringAsFixed(1)),
      tableId: table2.id!,
    );

    reports.addAll([report, report2]);
  }
  await reportState.addAll(reports);
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
  "44f9d543-c0f4-442e-8272-49d9d52adcf1", "8e8af749-49ac-4b12-92f6-d5afecda83f9", "b8c7ebed-0c7e-4327-9118-3dc94bf8a812", "7800ccdc-206e-4989-ad01-6852187d1032",
  "8ddb99fb-61aa-4603-8365-088bced4802d", "bca5768b-3d16-4957-be44-3f409bc8d81b", "2b5653f6-d14d-485a-83da-936b2f431264", "c92400fd-7500-4199-8dc6-0ff6bb3ee506",
  "37ed090c-f58c-4e6f-8ac1-2700c1cefcbc", "1b5387b6-f6ba-4df6-b633-224942a83c21", "7b9c8525-64dd-4980-8207-c20d38b87868", "89681913-79cb-4b99-ba96-2b438a761115",
  "7a5e4f94-71f2-4979-8c4c-647995bfcefa", "2af688ef-9899-45a8-b97a-b2527b57ac78", "6ddd406d-10de-41b0-8632-15a2797b6ef2", "9346f4c4-76b4-4b65-813f-5abaf632b21f",
  "ad33d3a8-d176-4685-a2bb-2ec83209e6f6", "594757fd-2be7-47b4-ae43-c61aae71bb30", "169f287e-99bb-405b-8c52-a4a47de18009", "abfaed2a-7066-4556-bd2d-cbf69c38902b",
  "bca9808b-c303-48c7-a094-7cf3208eea76",  "0af663ba-7740-4d8d-809e-41797df6bef", "4777c067-48c8-4b7d-906e-2ce202d2ef07", "a1feb240-de83-49d0-9124-b25ee37fb01b",
  "af64bbbd-e0a7-45eb-8990-52b4db16cea6", "4e52928f-1478-4210-971f-6bb5980f880f", "efb98202-7eae-4228-8925-39155905f87d", "6956b91a-379c-4351-9ac4-88c708d490d2",
  "0dc3ae3d-1926-4a91-9197-7bd896f5e331", "a167a480-3f63-42ba-8c29-e7742fe3eb5c", "2154c9ed-e031-48e0-8775-7b1ad268ac03", "4367feb2-af62-4401-a3e9-34e7923084dc",
  "f3ebfdd1-8f0f-412e-b750-ebbb167cd67c", "ecbec765-7fc0-4368-bec1-20e82a902d1f", "9d3722bb-df37-4daa-b0c4-b208ed206640", "b9a8a13c-f60f-43be-a206-2f29e2dfba2b",
  "5d612a08-05f3-4bee-b505-e945bdc7ad0c", "1c5f91de-8833-4729-a79b-4d97c75a89cb", "08ed510c-0c06-4b91-a18c-ca15d4fa613a", "694c356c-89ff-4036-a797-46ee5c3fd475",
  "e73a07a7-94dc-44ef-9d16-6cf7933bdd6d", "a95a0065-7e8c-4eca-a43e-f0d70a2bdf5a", "eeb51388-3a55-46a8-a2bd-fc7868c03247", "fcf939f4-aa7c-41d6-b375-7df6ea382dda",
  "73409972-2a40-4c90-ac8e-fab5f8f8b0ad", "9c80222e-e1fb-491a-89a4-16f75412dac6", "9bf64d1e-c3ac-4adc-9274-6b4f70f50881", "e49b4b0b-3b3e-4505-8bcc-f96794db01bf",
  "99f0db25-dc02-4def-8b79-7f125a7213ba", "c6808916-248f-47b0-801b-d99c38c7fba5", "bcc181a0-5447-4710-a931-48a3f7cab4b7", "34e67767-eea5-4b9c-bed7-57133302322f",
];