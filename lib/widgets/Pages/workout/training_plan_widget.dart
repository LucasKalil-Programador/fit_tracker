
import 'dart:async';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';

class TrainingPlanWidget extends StatefulWidget {
  final void Function(List<int>)? onDoneChange;

  final TrainingPlan trainingPlan;

  const TrainingPlanWidget({super.key, required this.trainingPlan, this.onDoneChange});

  @override
  State<TrainingPlanWidget> createState() => _TrainingPlanWidgetState();
}

class _TrainingPlanWidgetState extends State<TrainingPlanWidget> {
  Timer? saveDebounce;
  List<int> doneList = [];


  @override
  void initState() {
    super.initState();
    
    DatabaseHelper().getPlanExerciseList(widget.trainingPlan)
    .then((list) {
      setState(() {
        widget.trainingPlan.list = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = [];
    if(widget.trainingPlan.list != null) {
      exercises = widget.trainingPlan.list!;
    }
    
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          var item = exercises.removeAt(oldIndex);
          exercises.insert(newIndex, item);
        });
        saveOrder(exercises);
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

  void saveOrder(List<Exercise> exercises) {
    saveDebounce?.cancel();
    saveDebounce = Timer(Duration(seconds: 1), () {
      unawaited(DatabaseHelper().setPlanExerciseList(widget.trainingPlan, exercises));
    });
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
            if (selected == true) {
              doneList.add(exercise.id!);
            } else {
              doneList.remove(exercise.id!);
            }
            if (widget.onDoneChange != null) widget.onDoneChange!(doneList);
          });
        },
      ),
    );
  }
}