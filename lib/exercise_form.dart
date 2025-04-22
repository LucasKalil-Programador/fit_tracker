import 'package:flutter/material.dart';
import 'package:fittrackr/value_inpuit_widget.dart';

class Exercise {
  final String name;
  final int load;
  final int reps;
  final int series;

  const Exercise({
    required this.name,
    required this.load,
    required this.reps,
    required this.series,
  });

  @override
  String toString() {
    return 'Exercise(name: $name, load: $load kg, reps: $reps, series: $series)';
  }
}

class ExerciseForm extends StatefulWidget {
  final ValueChanged<Exercise>? onSubmit;

  const ExerciseForm({super.key, this.onSubmit});

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  late String name;
  int load = 1;
  int reps = 1;
  int series = 1;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Criação de Exercicio",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome Invalido';
                  }
                  name = value;
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ValueInputWidget(
                label: "Carga",
                suffix: "Kg",
                maxValue: 500,
                onChanged: (value) {
                  load = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ValueInputWidget(
                maxValue: 50,
                label: "Qtd. de repetições",
                suffix: "",
                onChanged: (value) {
                  reps = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ValueInputWidget(
                maxValue: 50,
                label: "Qtd. de series",
                suffix: "",
                onChanged: (value) {
                  series = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Exercise exercise = Exercise(
                      name: name,
                      reps: reps,
                      load: load,
                      series: series,
                    );
                    widget.onSubmit?.call(exercise);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(exercise.toString())),
                    );
                  }
                },
                child: const Text("Adicionar"),
              ),
            ), 
          ],
        ),
      ),
    );
  }
}
