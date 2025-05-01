
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/base_list_state.dart';

Future<void> saveMetadata(Map<String, String> data) async {
  print("------ Database call Metadata------");
  for (var element in data.entries) {
    print("${element.key}: ${element.value}");
  }
}

Future<void> saveExercise(Map<UpdateEvent, List<Exercise>> data) async {
  print("------ Database call Exercise ------");
  for (var element in data.entries) {
    print("${element.key}: ${element.value.length}");
  }
}

Future<void> saveTrainingPlan(Map<UpdateEvent, List<TrainingPlan>> data) async {
  print("------ Database call TrainingPlan ------");
  for (var element in data.entries) {
    print("${element.key}: ${element.value.length}");
  }
}