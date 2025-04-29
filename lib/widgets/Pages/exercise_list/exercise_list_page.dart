import 'package:fittrackr/states/exercises_state.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_card_widget.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets/forms/exercise_form.dart';
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
          DefaultDivider(),
          Expanded(
            child: Consumer<ExercisesState>(builder: (context, exerciseListState, child) {
              return ListView.builder(
                itemCount: exerciseListState.length,
                itemBuilder: (context, index) {
                  final exercise = exerciseListState.get(index);
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
            onSubmit: (value) async {
              Navigator.pop(context);

              final listState = Provider.of<ExercisesState>(context, listen: false);
              bool sucess = await listState.add(value);

              if(!context.mounted) return;
              showSnackMessage(context, sucess ? "Adicionado com sucesso!" : "Erro ao adicionar exercício!", sucess);
            },
            mode: ExerciseFormMode.creation,
            ),
        );
      },
    );
  }
}
