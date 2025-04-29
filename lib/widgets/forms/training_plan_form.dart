import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/exercises_state.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingPlanForm extends StatefulWidget {
  final void Function(TrainingPlan)? onSubmit;

  const TrainingPlanForm({super.key, this.onSubmit});

  @override
  State<TrainingPlanForm> createState() => _TrainingPlanFormState();
}

class _TrainingPlanFormState extends State<TrainingPlanForm> {
  TextEditingController _nameController = TextEditingController(text: "");
  List<Exercise> selected = [];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Criação de plano de treino",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 4),
                child: nameInput(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(
                          TrainingPlan(
                            name: _nameController.text,
                            list: selected,
                          ),
                        );
                      }
                    }
                  }, 
                  child: Text("Criar treino"),
                ),
              ),
              DefaultDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Selecione os exercícios", style: const TextStyle(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: exerciseSelection(),
              ), 
            ],
          ),
        ),
      ),
    );
  }

  Widget nameInput() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: "Nome"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nome Invalido';
        }
        return null;
      },
    );
  }

  Widget exerciseSelection() {
    return Consumer<ExercisesState>(
      builder: (context, exerciseListState, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: exerciseListState.length,
          itemBuilder: (context, index) {
            final exercise = exerciseListState.get(index);
            return DefaultExerciseCard(
              exercise: exercise,
              trailing: Checkbox(
                value: selected.indexOf(exercise) > -1,
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == null) return;
                    if (newValue) {
                      selected.add(exercise);
                    } else {
                      selected.remove(exercise);
                    }
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}