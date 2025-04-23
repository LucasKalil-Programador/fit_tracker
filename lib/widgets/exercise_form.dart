import 'package:fittrackr/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:fittrackr/widgets/value_inpuit_widget.dart';

class ExerciseFormMode {
  static const int creation = 0;
  static const int edit = 1;
}

class ExerciseForm extends StatefulWidget {
  final ValueChanged<Exercise>? onSubmit;
  final Exercise? baseExercise;
  final int mode;
  
  const ExerciseForm({super.key, this.onSubmit, this.mode = ExerciseFormMode.creation, this.baseExercise});

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
  void initState() {
    super.initState();
    if (widget.baseExercise != null) {
      name = widget.baseExercise!.name;
      load = widget.baseExercise!.load;
      reps = widget.baseExercise!.reps;
      series = widget.baseExercise!.series;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == 0 ? "Criação de exercicio" : "Editar exercicio",
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
                controller: TextEditingController(text: widget.baseExercise?.name),
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
                initalValue: widget.baseExercise?.load,
                maxValue: 500,
                onChanged: (value) {
                  load = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ValueInputWidget(
                label: "Qtd. de repetições",
                suffix: "",
                initalValue: widget.baseExercise?.reps,
                maxValue: 50,
                onChanged: (value) {
                  reps = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ValueInputWidget(
                label: "Qtd. de series",
                suffix: "",
                initalValue: widget.baseExercise?.series,
                maxValue: 50,
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
                  }
                },
                child: Text(widget.mode == 0 ? "Adicionar" : "Editar"),
              ),
            ), 
          ],
        ),
      ),
    );
  }
}
