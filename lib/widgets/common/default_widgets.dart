
import 'dart:math';

import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void showSnackMessage(BuildContext context, String message, bool sucess) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor:
          sucess
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.error,
    ),
  );
}

class DefaultDivider extends StatelessWidget {
  const DefaultDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: Theme.of(context).colorScheme.primary, thickness: 2);
  }
}

class DefaultExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final Widget? trailing;
  final Widget? leading;

  const DefaultExerciseCard({
    super.key,
    required this.exercise,
    this.trailing, 
    this.leading
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final typeStr = exercise.type == ExerciseType.musclework ? localization.kg : localization.minutes;
    return Card(
      key: super.key,
      //color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          exercise.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${exercise.sets}x${exercise.reps}   ${exercise.amount} $typeStr"),
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}

class DefaultTrainingPlanCard extends StatelessWidget {
  final TrainingPlan plan;
  final Widget? trailing;
  final Widget? leading;

  const DefaultTrainingPlanCard({super.key, required this.plan, this.trailing, this.leading});

  @override
  Widget build(BuildContext context) {
    final exerciseState = Provider.of<ExercisesState>(context);
    final localization = AppLocalizations.of(context)!;

    String substring = localization.exercisesLabel;
    List<String> subtitleList = [];

    if (plan.list != null && plan.list!.isNotEmpty) {
      for (int i = 0; i < min(plan.list!.length, 6); i++) {
        final exercise = exerciseState.getById(plan.list![i]);
        if (exercise != null) subtitleList.add(exercise.name);
      }
      substring = subtitleList.join(", ");
      if(plan.list!.length > 6) {
        substring = "$substring...";
      }
    } else {
      substring = localization.emptyList;
    }

    return Card(
      key: super.key,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          plan.name,
          softWrap: false,
          style: const TextStyle(fontWeight: FontWeight.bold,),
        ),
        subtitle: Text(substring),
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}

class DeleteBackground extends StatelessWidget {
  const DeleteBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
      ),
    );
  }
}

// For layout test
class Tile extends StatelessWidget {
  
  final int index;

  const Tile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final colorList = [
      Colors.red,
      Colors.black,
      Colors.white,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ];
    return Container(
        color: colorList[index == 0 ? 0 : index % colorList.length],
        child: Center(child: Text("$index", style: Theme.of(context).textTheme.titleLarge)),
    );
  }
}

