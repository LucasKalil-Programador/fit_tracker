import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/states/exercises_state.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_card_widget.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets/forms/exercise_form.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddModalBottom(context),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          DefaultDivider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: "Pesquisa"),
              onChanged: (value) {
                setState(() {
                  searchStr = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<ExercisesState>(builder: (context, exerciseListState, child) {
              final sortedList = exerciseListState.sorted()
                .where((e) => searchFilter(e, searchStr.toLowerCase()))
                .toList();
              return ListView.builder(
                itemCount: sortedList.length,
                itemBuilder: (context, index) {
                  final exercise = sortedList[index];
                  return ExerciseCard(exercise: exercise);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  bool searchFilter(Exercise exercise, String searchStr) {
    return exercise.name.toLowerCase().contains(searchStr) ||
           [exercise.reps, exercise.amount, exercise.sets].contains(int.tryParse(searchStr));
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
              Navigator.pop(context);
              final listState = Provider.of<ExercisesState>(context, listen: false);
              listState.add(value);
              showSnackMessage(context, "Adicionado com sucesso!", true);
            },
            mode: ExerciseFormMode.creation,
            ),
        );
      },
    );
  }
}
