import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/states/exercises_state.dart';
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
        onDismissed: (direction) async {
          final listState = Provider.of<ExercisesState>(context, listen: false);
          bool sucess = await listState.remove(exercise);

          if(!context.mounted) return;
          showSnackMessage(context, sucess ? "Removido com sucesso!" : "Erro ao remover exercício!", sucess);
        },              
        background: deleteBackground(),
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

  Widget deleteBackground() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
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

              final listState = Provider.of<ExercisesState>(context, listen: false);
              bool sucess = await listState.update(newExercise);
              print(newExercise);
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
