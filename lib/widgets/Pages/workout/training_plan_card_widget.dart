import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/training_plan_state.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingPlanCardWidget extends StatelessWidget {
  final void Function()? onStart;
  final void Function()? onEdit;
  final TrainingPlan plan;

  const TrainingPlanCardWidget({super.key, required this.plan, this.onStart, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(plan.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final trainingPlanState = Provider.of<TrainingPlanState>(context, listen: false);
        trainingPlanState.remove(plan);     
        showSnackMessage(context, "Removido com sucesso!", true);
      },
      background: DeleteBackground(),
      child: DefaultTrainingPlanCard(
        plan: plan,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: onStart,
                child: const Icon(Icons.play_arrow),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onEdit,
              child: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
