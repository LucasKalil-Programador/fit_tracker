import 'package:fittrackr/state/exercises_list_state.dart';
import 'package:fittrackr/widgets/exercise_card.dart';
import 'package:fittrackr/widgets/exercise_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lista de Exercicio",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddModalBottom(context),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Divider(color: Theme.of(context).colorScheme.primary, thickness: 2),
          Expanded(
            child: Consumer<ExerciseListState>(builder: (context, exerciseListState, child) {
              return ListView.builder(
                itemCount: exerciseListState.exercisesList.length,
                itemBuilder: (context, index) {
                  final exercise = exerciseListState.exercisesList[index];
                  return ExerciseCard(exercise: exercise);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void showAddModalBottom(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ExerciseForm(
            onSubmit: (value) {
              Provider.of<ExerciseListState>(context, listen: false).addExercise(value);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text("Adicionado com sucesso!"))
              );
            },
            mode: ExerciseFormMode.creation,
            ),
        );
      },
    );
  }
}
