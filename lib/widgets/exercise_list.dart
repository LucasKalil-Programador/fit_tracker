import 'package:fittrackr/entities/exercise.dart';
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
      child: Dismissible(
        key: Key(exercise.name),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Provider.of<ExerciseListState>(context, listen: false).removeExercise(exercise);
        },
        background: ClipRRect( 
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ExerciseForm(
                    onSubmit: (value) {
                      Provider.of<ExerciseListState>(context, listen: false,).removeExercise(exercise);
                      Provider.of<ExerciseListState>(context, listen: false,).addExercise(value);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text("Editado com sucesso!")),
                      );
                    },
                    mode: ExerciseFormMode.edit,
                    baseExercise: exercise,
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            shadowColor: Theme.of(context).colorScheme.surface,
            elevation: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Center(
                  child: Text(exercise.name, style: TextStyle(fontSize: 18)),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Carga: ${exercise.load} Kg",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Repetições: ${exercise.series}x${exercise.reps}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),    
      ),
    );
  }
}
