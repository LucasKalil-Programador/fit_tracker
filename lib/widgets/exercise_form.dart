import 'package:fittrackr/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:fittrackr/widgets/value_input_widget.dart';

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
  final _nameController = TextEditingController(text: "");
  int load = 1;
  int reps = 1;
  int sets = 1;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.baseExercise != null) {
      _nameController.text = widget.baseExercise!.name;
      load = widget.baseExercise!.load;
      reps = widget.baseExercise!.reps;
      sets = widget.baseExercise!.sets;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == 0 ? "Criação de exercicio" : "Editar exercicio",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView( 
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: nameInput(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: loadInput(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: repsInput(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: setsInput(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: submitButton(),
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

  Widget loadInput() {
    return ValueInputWidget(
      label: "Carga",
      suffix: "Kg",
      initialValue: widget.baseExercise?.load,
      maxValue: 500,
      onChanged: (value) => load = value,
    );
  }

  Widget repsInput() {
    return ValueInputWidget(
      label: "Qtd. de repetições",
      suffix: "",
      initialValue: widget.baseExercise?.reps,
      maxValue: 50,
      onChanged: (value) => reps = value,
    );
  }

  Widget setsInput() {
    return ValueInputWidget(
              label: "Qtd. de series",
              suffix: "",
              initialValue: widget.baseExercise?.sets,
              maxValue: 50,
              onChanged: (value) => sets = value,
            );
  }

  Widget submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shadowColor: Theme.of(context).colorScheme.shadow,
        elevation: 2,
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          String? newId;
          if (widget.mode == ExerciseFormMode.edit && widget.baseExercise != null) {
            newId = widget.baseExercise!.id;
          }
          Exercise exercise = Exercise(
            id: newId,
            name: _nameController.text,
            reps: reps,
            load: load,
            sets: sets,
          );
          widget.onSubmit?.call(exercise);
        }
      },
      child: Text(widget.mode == 0 ? "Adicionar" : "Editar"),
    );
  }
}
