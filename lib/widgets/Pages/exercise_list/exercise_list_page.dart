import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_card_widget.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseListPage extends StatefulWidget {

  const ExerciseListPage({super.key});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  String searchStr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lista de Exercicio",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          DefaultDivider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: "Pesquisa"),
              onChanged: (value) => setState(() => searchStr = value),
            ),
          ),
          Expanded(
            child: Consumer<ExercisesState>(builder: (context, exerciseListState, child) {
              final sortedList = exerciseListState.search(searchStr);
              sortedList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                return ExerciseListView(
                  sortedList: sortedList,
                  onDelete: (e) => onDelete(context, e),
                  onEdit: (e) => showEditModalBottom(context, e, ExerciseFormMode.edit),
                );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEditModalBottom(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void showEditModalBottom(BuildContext context, [Exercise? baseExercise, int mode = ExerciseFormMode.creation]) {
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

              if(mode == ExerciseFormMode.creation) {
                listState.add(newExercise);
                showSnackMessage(context, "Adicionado com sucesso!", true);
              } else {
                if(newExercise.id != null) {
                  int index = listState.indexWhere((entity) => entity.id == newExercise.id);
                  
                  if(index >= 0) {
                    listState[index] = newExercise;
                    showSnackMessage(context, "Editado com sucesso!", true);
                    return;
                  }
                }
                showSnackMessage(context, "Error ao editar!", false);
              }
            },
            mode: mode,
            baseExercise: baseExercise,
          ),
        );
      },
    );
  }

  void onDelete(BuildContext context, Exercise exercise) {
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
}


