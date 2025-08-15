import 'dart:async';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class TrainingPlanListView extends StatelessWidget {
  final void Function(TrainingPlan)? onStart, onDelete, onEdit;

  final TrainingPlanState trainingPlanState;

  const TrainingPlanListView({super.key, required this.trainingPlanState, this.onStart, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trainingPlanState.length,
      itemBuilder: (context, index) {
        final plan = trainingPlanState[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: TrainingPlanCardWidget(
            plan: plan, 
            onStart: () => {if(onStart != null) onStart!(plan)},
            onDelete: () => {if(onDelete != null) onDelete!(plan)},
            onEdit: () => {if(onEdit != null) onEdit!(plan)},
          )
        );
      },
    );
  }
}

class TrainingPlanCardWidget extends StatelessWidget {
  final void Function()? onStart, onDelete, onEdit;

  final TrainingPlan plan;

  const TrainingPlanCardWidget({super.key, required this.plan, this.onStart, this.onEdit, this.onDelete});
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localization = AppLocalizations.of(context)!;

    return Slidable(
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: .75,
        children: [
          SlidableAction(
            onPressed: (_) {if(onEdit != null) onEdit!();},
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            icon: Icons.edit,
            label: localization.edit,
          ),
          SlidableAction(
            onPressed: (_) {if(onStart != null) onStart!();},
            backgroundColor: colorScheme.secondaryContainer, 
            foregroundColor: colorScheme.onSecondaryContainer,
            icon: Icons.play_arrow,
            label: localization.start,
          ),
          SlidableAction(
            onPressed: (_) {if(onDelete != null) onDelete!();},
            backgroundColor: colorScheme.errorContainer,
            foregroundColor: colorScheme.onErrorContainer,
            icon: Icons.delete,
            label: localization.delete,
          ),
        ],
      ),
      child: DefaultTrainingPlanCard(plan: plan, trailing: Icon(Icons.swipe_right)),
    );
  }
}

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
  List<Exercise> exercises = [];
  List<String> exercisesId = [];
  List<String> donelist = [];
  
  double get progress => exercises.isEmpty ? 1 : donelist.length / exercises.length;
  String get progressString => "${(progress * 100).toInt().toString()}%";

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
              child: LinearPercentIndicator(
                addAutomaticKeepAlive: true,
                barRadius: Radius.circular(10),
                animation: true,
                animateFromLastPercent: true,
                animationDuration: 250,
                lineHeight: 30.0,
                percent: progress,
                center: Text(
                  progressString,
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
                  child: exerciseItem(exercises[i], i, context),
                ),
            ],
          ),
        ),
      ],
    );
  }

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
      final localization = AppLocalizations.of(context)!;
      if (exercises.length != exercisesId.length) {
        showSnackMessage(context, localization.loadWorkoutError, false);
        exercisesId = [];
        exercises = [];
      }
    });
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

  Widget exerciseItem(Exercise exercise, int index, BuildContext context) {
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