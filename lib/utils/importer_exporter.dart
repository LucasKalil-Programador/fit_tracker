import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Clear

Future<void> clearContext(BuildContext context) async {
  final eState = Provider.of<ExercisesState>(context, listen: false);
  final pState = Provider.of<TrainingPlanState>(context, listen: false);
  final rState = Provider.of<ReportState>(context, listen: false);
  final tState = Provider.of<ReportTableState>(context, listen: false);
  final thState = Provider.of<TrainingHistoryState>(context, listen: false);
  final mState = Provider.of<MetadataState>(context, listen: false);
  await Future.wait([
    eState.clear(),
    pState.clear(),
    rState.clear(),
    tState.clear(),
    thState.clear(),
    mState.clear(),
  ]);
}