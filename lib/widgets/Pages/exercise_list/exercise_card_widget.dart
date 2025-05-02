import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/states/exercises_state.dart';
import 'package:fittrackr/states/training_plan_state.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets/forms/exercise_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {

  final Exercise exercise;
  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Dismissible(
        key: ValueKey(exercise.id!),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => onDismissed(context),              
        background: DeleteBackground(),
        child: contentCard(context),    
      ),
    );
  }

  Widget contentCard(BuildContext context) {
    return DefaultExerciseCard(
      exercise: this.exercise,
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary
        ),
        onPressed: () => showEditModalBottom(context),
        child: const Icon(Icons.edit),
      ),
    );
  } 

  void onDismissed(BuildContext context) {
    final exercisesState = Provider.of<ExercisesState>(context, listen: false);
    final trainingPlanState = Provider.of<TrainingPlanState>(context, listen: false);
    
    exercisesState.remove(exercise);
    
    while(true) {
      int index = trainingPlanState.indexWhere((p) => p.list?.contains(exercise.id) == true);
      if(index == -1) break;
      trainingPlanState[index].list?.remove(exercise.id);
      trainingPlanState.reportUpdate(trainingPlanState[index]);
    }
            
    showSnackMessage(context, "Removido com sucesso!", true);
  }

  void showEditModalBottom(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ExerciseForm(
            onSubmit: (newExercise) {
              Navigator.pop(context);
              final listState = Provider.of<ExercisesState>(context, listen: false);
              listState[listState.indexOf(exercise)] = newExercise;
              showSnackMessage(context, "Editado com sucesso!", true);
            },
            mode: ExerciseFormMode.edit,
            baseExercise: exercise,
          ),
        );
      },
    );
  } 
}

