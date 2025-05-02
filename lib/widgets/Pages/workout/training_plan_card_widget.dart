import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TrainingPlanCardWidget extends StatelessWidget {
  final void Function()? onStart;
  final void Function()? onDelete;
  final void Function()? onEdit;

  final TrainingPlan plan;

  const TrainingPlanCardWidget({super.key, required this.plan, this.onStart, this.onEdit, this.onDelete});
  
  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: DefaultTrainingPlanCard(plan: plan, trailing: Icon(Icons.swipe_right)),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: .75,
        children: [
          SlidableAction(
            onPressed: (_) {if(onEdit != null) onEdit!();},
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Editar',
          ),
          SlidableAction(
            onPressed: (_) {if(onStart != null) onStart!();},
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            foregroundColor: Colors.white,
            icon: Icons.play_arrow,
            label: 'Iniciar',
          ),
          SlidableAction(
            onPressed: (_) {if(onDelete != null) onDelete!();},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
    );
  }
}
