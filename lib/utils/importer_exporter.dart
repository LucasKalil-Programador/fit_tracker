
import 'dart:convert';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const exerciseJsonKey = "Exercises";
const plansJsonKey = "Plans";
const tablesJsonKey = "Tables";
const reportsJsonKey = "Reports";

// Importer

class Data {
  List<Exercise>? exercises;
  List<TrainingPlan>? plans;
  List<ReportTable>? tables;
  List<Report>? reports;
}

Data jsonToData(String data) {
  Data result = Data();
  _import(data, result);
  _validFields(result);
  _filterInvalidForeignKey(result);
  return result;
}

Future<void> dataToContext(Data data, BuildContext context, bool clearContextBefore) async {
    final eState = Provider.of<ExercisesState>(context, listen: false);
    final pState = Provider.of<TrainingPlanState>(context, listen: false);
    final rState = Provider.of<ReportState>(context, listen: false);
    final tState = Provider.of<ReportTableState>(context, listen: false);
    
    if(clearContextBefore) {
      await eState.clear();
      await pState.clear();
      await rState.clear();
      await tState.clear();
    }
    
    await eState.addAll(data.exercises ?? []);
    await pState.addAll(data.plans ?? []);
    await rState.addAll(data.reports ?? []);
    await tState.addAll(data.tables ?? []);
}

void _import(String data, Data result) {
  final json = jsonDecode(data);
  
  if(json is Map<String, dynamic>) {
    final hasKeys =
        json.containsKey(exerciseJsonKey) &&
        json.containsKey(plansJsonKey) &&
        json.containsKey(tablesJsonKey) &&
        json.containsKey(reportsJsonKey);
  
    if(hasKeys) {
      final exercisesJson = json[exerciseJsonKey];
      final plansJson = json[plansJsonKey];
      final tablesJson = json[tablesJsonKey];
      final reportsJson = json[reportsJsonKey];
  
      if(exercisesJson is List<dynamic>) {
        result.exercises = exercisesJson.cast<Map<String, Object?>>()
          .map(Exercise.fromMap)
          .where((element) => element != null)
          .toList().cast();
      }

      if(plansJson is List<dynamic>) {
        result.plans = plansJson.cast<Map<String, Object?>>()
          .map(TrainingPlan.fromMap)
          .where((element) => element != null)
          .toList().cast();
      }

      if(tablesJson is List<dynamic>) {
        result.tables = tablesJson.cast<Map<String, Object?>>()
          .map(ReportTable.fromMap)
          .where((element) => element != null)
          .toList().cast();
      }

      if(reportsJson is List<dynamic>) {
        result.reports = reportsJson.cast<Map<String, Object?>>()
          .map(Report.fromMap)
          .where((element) => element != null)
          .toList().cast();
      }
    }
  }
}

void _filterInvalidForeignKey(Data result) {
  if(result.plans != null && result.exercises != null) {
    for (var plan in result.plans!) {
      final list = plan.list ?? [];
      plan.list = list.where((item) => result.exercises!.any((element) => element.id == item)).toList();
    }
  } 

  if(result.tables != null && result.reports != null) {
    final list = result.reports;
    result.reports = list?.where((item) => result.tables!.any((element) => element.id == item.tableId,)).toList();
  }
}

void _validFields(Data result) {
  result.exercises?.removeWhere((item) => !item.isValid);
  result.plans?.removeWhere((item) => !item.isValid);
  result.tables?.removeWhere((item) => !item.isValid);
  result.reports?.removeWhere((item) => !item.isValid);
}

// Clear

Future<void> clearContext(BuildContext context) async {
  final eState = Provider.of<ExercisesState>(context, listen: false);
  final pState = Provider.of<TrainingPlanState>(context, listen: false);
  final rState = Provider.of<ReportState>(context, listen: false);
  final tState = Provider.of<ReportTableState>(context, listen: false);
  final thState = Provider.of<TrainingHistoryState>(context, listen: false);
  await eState.clear();
  await pState.clear();
  await rState.clear();
  await tState.clear();
  await thState.clear();
}