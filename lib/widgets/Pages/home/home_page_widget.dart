import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowCurrentActivePlan extends StatelessWidget {
  final void Function()? onClick;

  const ShowCurrentActivePlan({
    super.key,
    this.onClick
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Consumer2<TrainingPlanState, MetadataState>(
      builder: (BuildContext context, TrainingPlanState trainingPlanState, MetadataState metadataState, Widget? child) { 
        TrainingPlan? activatedPlan = getActivatedPlan(metadataState, trainingPlanState);
        double progress = getProgress(activatedPlan, metadataState);

        return ListTile(
          title: Text(
            activatedPlan != null ? localization.activeTraining : localization.inactiveTraining,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            activatedPlan?.name ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(onPressed: onClick, icon: Icon(Icons.arrow_forward_ios)),
          leading: CircularProgressWithText(progress: progress),
          tileColor: Theme.of(context).colorScheme.primaryContainer,
        );
      },
    );
  }

  double getProgress(TrainingPlan? activatedPlan, MetadataState metadataState) {
    if(activatedPlan != null) {
      if(metadataState.containsKey(metadataDoneKey)) {
        final donelist = metadataState.getList(metadataDoneKey);
        if(donelist is List<String> && activatedPlan.list is List<String>) {
          if(activatedPlan.list!.isEmpty) return 100;
          return (donelist.length.toDouble() / activatedPlan.list!.length) * 100;
        }
      }
    }
    return 100;
  }

  TrainingPlan? getActivatedPlan(MetadataState metadataState, TrainingPlanState trainingPlanState) {
    if(metadataState.containsKey(metadataActivatedKey)) {
      final activatedPlanId = metadataState.get(metadataActivatedKey)!;
      final index = trainingPlanState.indexWhere((plan) => plan.id == activatedPlanId);
      if(index >= 0) return trainingPlanState.get(index);
    }
    return null;
  }
}

class CircularProgressWithText extends StatelessWidget {
  final double progress;
  final double size;

  const CircularProgressWithText({
    super.key,
    required this.progress,
    this.size = 40, // valor padrão
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0, 100);
    final percentValue = clampedProgress / 100;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percentValue,
            strokeWidth: size * 0.12,
          ),
          Text(
            '${clampedProgress.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: size * 0.28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
