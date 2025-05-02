import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/training_plan_state.dart';
import 'package:fittrackr/widgets/Pages/workout/training_plan_card_widget.dart';
import 'package:flutter/material.dart';

class TrainingPlanListView extends StatelessWidget {
  final void Function(TrainingPlan)? onStart;
  final void Function(TrainingPlan)? onEdit;

  final TrainingPlanState trainingPlanState;

  const TrainingPlanListView({super.key, required this.trainingPlanState, this.onStart, this.onEdit});

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
            onEdit: () => {if(onStart != null) onEdit!(plan)},
          )
        );
      },
    );
  }
}