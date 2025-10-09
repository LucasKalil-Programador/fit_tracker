import 'package:fittrackr/Models/exercise.dart';
import 'package:fittrackr/Providers/exercise_form.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets_v2/Pages/int_value_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ExerciseFormMode {
  creation, edit;
}

class ExerciseForm extends ConsumerStatefulWidget {
  final ValueChanged<Exercise>? onSubmit;
  final Exercise? baseExercise;
  final ExerciseFormMode mode;
  
  const ExerciseForm({super.key, this.onSubmit, this.baseExercise, this.mode = ExerciseFormMode.creation});

  @override
  ConsumerState<ExerciseForm> createState() => _ExerciseFormState();
}

class _ExerciseFormState extends ConsumerState<ExerciseForm> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: ref.read(exerciseFormControllerProvider).name,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == ExerciseFormMode.creation ? localization.createExercise : localization.editExercise,
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
                child: nameInput(localization),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: amountInput(localization),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: typeInput(localization)
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: repsInput(localization),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: setsInput(localization),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: submitButton(localization),
              ), 
            ],
          ),
        ),
      ),
    );
  }

  Widget typeInput(AppLocalizations localization) {
    final type = ref.watch(exerciseFormControllerProvider.select((value) => value.type));

    return Column(
      children: [
        ListTile(
          title: Text(localization.strength),
          leading: Radio<ExerciseType>(
            value: ExerciseType.musclework,
            groupValue: type,
            onChanged: (exerciseType) {
              if(exerciseType == null) return;
              ref.read(exerciseFormControllerProvider.notifier).updateType(exerciseType);
            },
          ),
        ),
        ListTile(
          title: Text(localization.cardio),
          leading: Radio<ExerciseType>(
            value: ExerciseType.cardio,
            groupValue: type,
            onChanged: (exerciseType) {
              if(exerciseType == null) return;
              ref.read(exerciseFormControllerProvider.notifier).updateType(exerciseType);
            },
          ),
        ),
      ],
    );
  }

  Widget nameInput(AppLocalizations localization) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(labelText: localization.name),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localization.invalidName;
        }
        return null;
      },
      onChanged: (value) {
        ref.read(exerciseFormControllerProvider.notifier).updateName(value);
      },
    );
  }

  Widget amountInput(AppLocalizations localization) {
    final data = ref.watch(exerciseFormControllerProvider);
    return IntValueInput(
      label: data.type == ExerciseType.musclework ? localization.weightLoad : localization.time,
      suffix: data.type == ExerciseType.musclework ? localization.kg : localization.minutes,
      value: data.amount,
      min: 0, max: 500,
      onChanged: ref.read(exerciseFormControllerProvider.notifier).updateAmount,
    );
  }

  Widget repsInput(AppLocalizations localization) {
    final reps = ref.watch(exerciseFormControllerProvider.select((e) => e.reps,));
    return IntValueInput(
      label: localization.reps,
      value: reps,
      suffix: "",
      min: 0, max: 500,
      onChanged: ref.read(exerciseFormControllerProvider.notifier).updateReps
    );
  }

  Widget setsInput(AppLocalizations localization) {
    final sets = ref.watch(exerciseFormControllerProvider.select((e) => e.sets,));
    return IntValueInput(
      label: localization.sets,
      value: sets,
      suffix: "",
      min: 0, max: 500,
      onChanged: ref.read(exerciseFormControllerProvider.notifier).updateSets,
    );
  }

  String? validateData(AppLocalizations localization) {
    final data = ref.read(exerciseFormControllerProvider);
    if(data.reps < 0 || data.reps > 500) {
      return localization.invalidReps;
    } 

    if(data.sets < 0 || data.sets > 500) {
      return localization.invalidSets;
    } 

    if(data.amount < 0 || data.amount > 2) {
      return localization.invalidAmount;
    } 

    if(data.name.isEmpty) {
      return localization.invalidName;
    }

    return null;
  }

  Widget submitButton(AppLocalizations localization) {
    return ElevatedButton(
      onPressed: () {
        final data = ref.read(exerciseFormControllerProvider);
        final valid = validateData(localization);

        if(valid != null) {
          showSnackMessage(context, valid, false);
        }

        if (_formKey.currentState!.validate() && valid == null) {
          String? newId;
          if (widget.mode == ExerciseFormMode.edit && widget.baseExercise != null) {
            newId = widget.baseExercise!.id;
          }
          Exercise exercise = Exercise(
            id: newId,
            name: _nameController.text,
            reps: data.reps,
            amount: data.amount,
            sets: data.sets,
            type: data.type, 
            category: "" // TODO category
          );
          widget.onSubmit?.call(exercise);
        }
      },
      child: Text(widget.mode == ExerciseFormMode.creation ? localization.add : localization.edit),
    );
  }
}
