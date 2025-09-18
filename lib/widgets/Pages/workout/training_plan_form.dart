import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingPlanFormMode {
  static const int creation = 0;
  static const int edit = 1;
}

class TrainingPlanForm extends StatefulWidget {
  final void Function(TrainingPlan)? onSubmit;
  final TrainingPlan? baseTrainingPlan;
  final int mode;

  const TrainingPlanForm({super.key, this.onSubmit, this.baseTrainingPlan, this.mode = TrainingPlanFormMode.creation});

  @override
  State<TrainingPlanForm> createState() => _TrainingPlanFormState();
}

class _TrainingPlanFormState extends State<TrainingPlanForm> {
  late final localization = AppLocalizations.of(context)!;
  TextEditingController nameController = TextEditingController(text: "");
  List<String> selected = [];
  String searchStr = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.baseTrainingPlan != null) {
      nameController.text = widget.baseTrainingPlan!.name;
      if(widget.baseTrainingPlan!.list != null) {
        selected.addAll(widget.baseTrainingPlan!.list!);
      } 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          localization.createPlan,
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
                  onPressed: submit, 
                  child: Text(widget.mode == TrainingPlanFormMode.creation ? localization.createWorkout : localization.editWorkout),
                ),
              ),
              DefaultDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(localization.selectExercises, style: const TextStyle(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(labelText: localization.search),
                  onChanged: (value) {
                    setState(() {
                      searchStr = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: exerciseSelection(),
                ),
              ), 
            ],
          ),
        ),
      ),
    );
  }

  Widget nameInput() {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(labelText: localization.name),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localization.invalidName;
        }
        return null;
      },
    );
  }

  Widget exerciseSelection() {
    return Consumer<ExercisesState>(
      builder: (context, exerciseListState, child) {
        final exercises = exerciseListState.search(searchStr);

        return ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return DefaultExerciseCard(
              exercise: exercise,
              trailing: Checkbox(
                value: selected.contains(exercise.id),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == null) return;
                    if (newValue) {
                      selected.add(exercise.id!);
                    } else {
                      selected.remove(exercise.id!);
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

  void submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.onSubmit != null) {
          String? id;
          if(widget.baseTrainingPlan != null && widget.mode == TrainingPlanFormMode.edit) {
            id = widget.baseTrainingPlan?.id;
        }
        final plan = TrainingPlan(id: id, name: nameController.text, list: selected);
        widget.onSubmit!(plan);
      }
    }
  }
}