import 'package:fittrackr/state/exercises_list_state.dart';
import 'package:fittrackr/widgets/exercise_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

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
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.all(
                  16,
                ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ExerciseForm(onSubmit: (value) {
                  Navigator.pop(context);
                  Provider.of<ExerciseListState>(context, listen: false).addExercise(value);
                },),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: Consumer<ExerciseListState>(builder: (context, exerciseListState, child) {
        return ListView.builder(
          itemCount: exerciseListState.exercisesList.length,
          itemBuilder: (context, index) {
            final exercise = exerciseListState.exercisesList[index];
            return ExerciseCard(exercise: exercise);
          },
        );
      }),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: Center(child: Text(exercise.name, style: TextStyle(fontSize: 18)))),
                Expanded(
                  child: Column(children: [
                    Text("Carga: ${exercise.load} Kg", style: TextStyle(fontSize: 16),),
                    Text("Repetições: ${exercise.series}x${exercise.reps}", style: TextStyle(fontSize: 16),)
                  ],),
                )
              ],
            ),
        ),
    );
  }
}
