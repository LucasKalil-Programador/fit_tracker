import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExerciseListView extends StatelessWidget {
  final void Function(Exercise)? onDelete, onEdit;

  final List<Exercise> sortedList;

  const ExerciseListView({
    super.key,
    required this.sortedList, this.onDelete, this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sortedList.length,
      itemBuilder: (context, index) {
        final exercise = sortedList[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ExerciseCard(
            exercise: exercise,
            onEdit: () => {if (onEdit != null) onEdit!(exercise)},
            onDelete: () => {if (onDelete != null) onDelete!(exercise)},
          ),
        );
      },
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final void Function()? onDelete, onEdit;
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: .5,
        children: [
          SlidableAction(
            onPressed: (_) {if(onEdit != null) onEdit!();},
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Editar',
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
      child: DefaultExerciseCard(exercise: this.exercise, trailing: Icon(Icons.swipe_right)),
    );
  }
}

