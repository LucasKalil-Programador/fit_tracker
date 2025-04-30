
import 'dart:async';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/exercises_state.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingPlanWidget extends StatefulWidget {
  final void Function(List<String>)? onDoneChange;

  final TrainingPlan trainingPlan;
  final List<String>? donelist;

  const TrainingPlanWidget({super.key, required this.trainingPlan, this.onDoneChange, this.donelist});

  @override
  State<TrainingPlanWidget> createState() => _TrainingPlanWidgetState();
}

class _TrainingPlanWidgetState extends State<TrainingPlanWidget> {
  Timer? saveDebounce;
  List<String> donelist = [];


  @override
  void initState() {
    super.initState();
    if(widget.donelist != null) donelist = widget.donelist!;
  }

  @override
  Widget build(BuildContext context) {
    final exercisesState = Provider.of<ExercisesState>(context);
    final List<Exercise> exercises = [];
    List<String> exercisesId = [];
    if(widget.trainingPlan.list != null) {
      exercisesId = widget.trainingPlan.list!;
      for (var element in exercisesId) {
        final exercise = exercisesState.getById(element);
        if(exercise != null) exercises.add(exercise);
      }
    }
    
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          var item = exercisesId.removeAt(oldIndex);
          exercisesId.insert(newIndex, item);
        });
      },
      children: [
        for (int i = 0; i < exercises.length; i++)
          Padding(
            key: ValueKey(exercises[i].id!),
            padding: const EdgeInsets.all(4.0),
            child: _planItem(exercises[i], i, context),
          ),
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
        value: donelist.contains(exercise.id),
        onChanged: (selected) {
          setState(() {
            if (selected == true) {
              donelist.add(exercise.id!);
            } else {
              donelist.remove(exercise.id!);
            }
            if (widget.onDoneChange != null) widget.onDoneChange!(donelist);
          });
        },
      ),
    );
  }
}