
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:flutter/material.dart';

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
    final typeStr = exercise.type == ExerciseType.Musclework ? "Kg" : "Minutos";
    return Card(
      key: super.key,
      //color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          exercise.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${exercise.sets}x${exercise.reps}   ${exercise.amount} ${typeStr}"),
        leading: this.leading,
        trailing: this.trailing,
      ),
    );
  }
}

class DefaultTrainingPlanCard extends StatelessWidget {
  final TrainingPlan plan;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? leading;

  const DefaultTrainingPlanCard({super.key, required this.plan, this.trailing, this.leading, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: super.key,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          plan.name,
          softWrap: false,
          style: const TextStyle(fontWeight: FontWeight.bold,),
        ),
        subtitle: this.subtitle,
        leading: this.leading,
        trailing: this.trailing,
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

