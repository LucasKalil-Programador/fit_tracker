
import 'package:fittrackr/entities/exercise.dart';
import 'package:flutter/material.dart';

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
    return Card(
      key: super.key,
      //color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          exercise.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${exercise.sets}x${exercise.reps}   ${exercise.load} Kg"),
        leading: this.leading,
        trailing: this.trailing,
      ),
    );
  }
}

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
