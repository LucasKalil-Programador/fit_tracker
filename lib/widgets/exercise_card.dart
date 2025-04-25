import 'package:fittrackr/entities/exercise.dart';
import 'package:fittrackr/state/exercises_list_state.dart';
import 'package:fittrackr/widgets/exercise_form.dart';
import 'package:fittrackr/widgets/widget_utils.dart';
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
        onDismissed: (direction) async {
          bool sucess = await Provider.of<ExerciseListState>(context, listen: false).removeExercise(exercise);
          if(!context.mounted) return;
          showSnackMessage(context, sucess ? "Removido com sucesso!" : "Erro ao remover exercício!", sucess);
        },              
        background: deleteButton(),
        child: contentButton(context),    
      ),
    );
  }

  ElevatedButton contentButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () => showEditModalBottom(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shadowColor: Theme.of(context).colorScheme.shadow,
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Center(
                child: Text(exercise.name, style: const TextStyle(fontSize: 18)),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Carga: ${exercise.load} Kg",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Repetições: ${exercise.sets}x${exercise.reps}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  ClipRRect deleteButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  void showEditModalBottom(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ExerciseForm(
            onSubmit: (newExercise) async {
              Navigator.pop(context);
              bool sucess = await Provider.of<ExerciseListState>(context, listen: false,).updateExercise(newExercise);
              
              if(!context.mounted) return;
              showSnackMessage(context, sucess ? "Editado com sucesso!" : "Erro ao editar exercício!", sucess);
            },
            mode: ExerciseFormMode.edit,
            baseExercise: exercise,
          ),
        );
      },
    );
  } 
}
