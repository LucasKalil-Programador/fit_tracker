
import 'package:fittrackr/entities/exercise.dart';
import 'package:fittrackr/entities/exercise_plan.dart';
import 'package:flutter/material.dart';

class ExercisePlanWidget extends StatefulWidget {
  final ExercisePlan exercisePlan;
  final bool editMode;

  const ExercisePlanWidget({super.key, this.editMode = false, required this.exercisePlan});

  @override
  State<ExercisePlanWidget> createState() => _ExercisePlanWidgetState();
}

class _ExercisePlanWidgetState extends State<ExercisePlanWidget> {
  @override
  Widget build(BuildContext context) {
    List<ExercisePlanRecipient> exercises = widget.exercisePlan.exercises;

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          var item = exercises.removeAt(oldIndex);
          exercises.insert(newIndex, item);
        });
      },
      children: [
        for (int index = 0; index < exercises.length; index += 1)
          _planItem(exercises[index], index, context),
      ],
    );
  }

  Card _planItem(ExercisePlanRecipient item, int index, BuildContext context) {
    Exercise exercise = item.exercise;
    return Card(
        key: Key(exercise.id!),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: ListTile(
          title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("${exercise.sets}x${exercise.reps}   ${exercise.load} Kg"),
          leading: Text("${index + 1}", textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          trailing:
            widget.editMode? ReorderableDragStartListener(
                  index: index,
                  child: Icon(Icons.drag_indicator),
                ) : Checkbox(
                  value: item.done,
                  onChanged: (selected) {
                    setState(() => item.done = !item.done);
                  },
                ),
      ),
    );
  }
}