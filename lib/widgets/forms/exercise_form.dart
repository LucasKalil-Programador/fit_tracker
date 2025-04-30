import 'package:flutter/material.dart';
import 'package:fittrackr/widgets/common/value_input_widget.dart';
import 'package:fittrackr/database/entities/exercise.dart';

class ExerciseFormMode {
  static const int creation = 0;
  static const int edit = 1;
}

class ExerciseForm extends StatefulWidget {
  final ValueChanged<Exercise>? onSubmit;
  final Exercise? baseExercise;
  final int mode;
  
  const ExerciseForm({super.key, this.onSubmit, this.baseExercise, this.mode = ExerciseFormMode.creation});

  @override
  State<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final _nameController = TextEditingController(text: "");
  ExerciseType type = ExerciseType.Musclework;
  int amount = 1;
  int reps = 1;
  int sets = 1;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.baseExercise != null) {
      _nameController.text = widget.baseExercise!.name;
      amount = widget.baseExercise!.amount;
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
                child: amountInput(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: typeInput()
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

  Widget typeInput() {
    return Column(
      children: [
        ListTile(
          title: const Text("Musculação"),
          leading: Radio<ExerciseType>(
            value: ExerciseType.Musclework,
            groupValue: type,
            onChanged: (exerciseType) {
              setState(() {
                type = exerciseType!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text("Cardio"),
          leading: Radio<ExerciseType>(
            value: ExerciseType.Cardio,
            groupValue: type,
            onChanged: (exerciseType) {
              setState(() {
                type = exerciseType!;
              });
            },
          ),
        ),
      ],
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

  Widget amountInput() {
    return ValueInputWidget(
      label: type == ExerciseType.Musclework ? "Carga" : "Tempo",
      suffix: type == ExerciseType.Musclework ? "Kg" : "Minutos",
      initialValue: widget.baseExercise?.amount,
      maxValue: 500,
      onChanged: (value) => amount = value,
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
            amount: amount,
            sets: sets,
            type: type
          );
          widget.onSubmit?.call(exercise);
        }
      },
      child: Text(widget.mode == 0 ? "Adicionar" : "Editar"),
    );
  }
}
