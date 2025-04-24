import 'package:fittrackr/entities/exercise_plan.dart';
import 'package:fittrackr/state/exercise_plan_state.dart';
import 'package:fittrackr/state/timer_state.dart';
import 'package:fittrackr/widgets/exercise_plan_widget.dart';
import 'package:fittrackr/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Treino",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Divider(color: Theme.of(context).colorScheme.primary, thickness: 2),
          Consumer<TimerState>(
            builder: (context, timerState, child) => TimerWidget(timerState: timerState),
          ),
          Divider(color: Theme.of(context).colorScheme.primary, thickness: 2),
          Expanded(
            child: Consumer<ExercisePlanState>(
              builder: (context, exercisePlanState, child) {
                ExercisePlan? plan = exercisePlanState.getActivated();
                if(plan != null) {
                  return ExercisePlanWidget(exercisePlan: plan);
                }
                return Placeholder();
              },
            ),
          ),
        ],
      ),
    );
  }
}