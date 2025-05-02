
import 'dart:async';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/exercises_state.dart';
import 'package:fittrackr/states/training_plan_state.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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

  List<String> exercisesId = [];
  List<Exercise> exercises = [];

  double get progress => donelist.length / exercises.length;

  @override
  void initState() {
    super.initState();
    if(widget.donelist != null) donelist = widget.donelist!;

    loadExercises();
  }

  void loadExercises() {
    final exercisesState = Provider.of<ExercisesState>(context, listen: false);
    if(widget.trainingPlan.list != null) {
      exercisesId = widget.trainingPlan.list!;
      for (var element in exercisesId) {
        final exercise = exercisesState.getById(element);
        if(exercise != null) exercises.add(exercise);
      }
    }
    
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (exercises.length != exercisesId.length) {
        showSnackMessage(context, "Erro ao carregar o treino", false);
        exercisesId = [];
        exercises = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.trainingPlan.name,
          style: Theme.of(context).textTheme.titleLarge,
          softWrap: false,
        ),
        Padding(
              padding: EdgeInsets.all(8.0),
              child: new LinearPercentIndicator(
                addAutomaticKeepAlive: true,
                barRadius: Radius.circular(10),
                animation: true,
                animateFromLastPercent: true,
                animationDuration: 250,
                lineHeight: 30.0,
                percent: progress,
                center: Text(
                  "${(progress * 100).toInt().toString()}%",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                progressColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
        Expanded(
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) => onReorder(oldIndex, newIndex, context),
            children: [
              for (int i = 0; i < exercises.length; i++)
                Padding(
                  key: ValueKey(exercises[i].id!),
                  padding: const EdgeInsets.all(4.0),
                  child: _planItem(exercises[i], i, context),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void onReorder(int oldIndex, int newIndex, BuildContext context) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item1 = exercisesId.removeAt(oldIndex);
      exercisesId.insert(newIndex, item1);

      final item2 = exercises.removeAt(oldIndex);
      exercises.insert(newIndex, item2);
    });
    
    if(widget.trainingPlan.list != null) {
        Provider.of<TrainingPlanState>(context, listen: false)
        .reportUpdate(widget.trainingPlan);
    }
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