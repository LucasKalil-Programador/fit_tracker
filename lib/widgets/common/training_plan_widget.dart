
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';

class TrainingPlanWidget extends StatefulWidget {
  final TrainingPlan trainingPlan;

  const TrainingPlanWidget({super.key, required this.trainingPlan});

  @override
  State<TrainingPlanWidget> createState() => _TrainingPlanWidgetState();
}

class _TrainingPlanWidgetState extends State<TrainingPlanWidget> {
  List<int> doneList = [];

  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = [];
    if(widget.trainingPlan.list != null) {
      exercises = widget.trainingPlan.list!;
    }
    
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

  Widget _planItem(Exercise exercise, int index, BuildContext context) {
    return DefaultExerciseCard(
      key: ValueKey(exercise.id!),
      exercise: exercise,
      leading: Text(
        "${index + 1}",
        textAlign: TextAlign.right,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      trailing: Checkbox(
        value: doneList.contains(exercise.id),
        onChanged: (selected) {
          setState(() {
            if(selected == true) {
              doneList.add(exercise.id!);
            } else {
              doneList.remove(exercise.id!);
            }
          });
        },
      ),
    );
  }
}