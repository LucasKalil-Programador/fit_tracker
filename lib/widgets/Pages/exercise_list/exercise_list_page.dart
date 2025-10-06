import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_list_view.dart';
import 'package:fittrackr/widgets/Pages/exercise_list/exercise_form.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseListPage extends StatefulWidget {

  const ExerciseListPage({super.key});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  late AppLocalizations localization;

  bool isDeleting = false;
  bool isSubmitting = false;
  String searchStr = "";

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.exerciseList,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          DefaultDivider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: localization.search),
              onChanged: (value) => setState(() => searchStr = value),
            ),
          ),
          Expanded(
            child: Consumer<ExercisesState>(builder: (context, exerciseListState, child) {
              final sortedList = exerciseListState.search(searchStr);
              sortedList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                return ExerciseListView(
                  sortedList: sortedList,
                  onDelete: (e) => isDeleting ? null : onDelete(context, e),
                  onEdit: (e) => showEditModalBottom(context, e, ExerciseFormMode.edit),
                );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEditModalBottom(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void showEditModalBottom(BuildContext context, [Exercise? baseExercise, int mode = ExerciseFormMode.creation]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ExerciseForm(
            onSubmit: (newExercise) => isSubmitting ? null : onSubmit(newExercise, mode),
            mode: mode,
            baseExercise: baseExercise,
          ),
        );
      },
    );
  }

  void onSubmit(Exercise newExercise, int mode) async {
    if(isSubmitting) return;
    setState(() => isSubmitting = true);

    try {
      final listState = Provider.of<ExercisesState>(context, listen: false);
      bool success = false;

      if(mode == ExerciseFormMode.creation) {
        success = await listState.add(newExercise);
      } else if(newExercise.id != null) {
        success = await listState.reportUpdate(newExercise);
      }

      if(mounted) {
        showSnackMessage(
          context,
          success
            ? (mode == ExerciseFormMode.creation
                ? localization.addedSuccess
                : localization.editedSuccess)
            : (mode == ExerciseFormMode.creation 
                ? localization.addError 
                : localization.editError),
          success,
        );
        
        if(success) Navigator.pop(context);
      }
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  void onDelete(BuildContext context, Exercise exercise) async {
    if(isDeleting) return;
    setState(() => isDeleting = true);

    try {
      final exercisesState = Provider.of<ExercisesState>(context, listen: false);
      final trainingPlanState = Provider.of<TrainingPlanState>(context, listen: false);
      
      final removeResult = await exercisesState.remove(exercise);
      
      if(removeResult) {
        while(true) {
          int index = trainingPlanState.indexWhere((p) => p.list?.contains(exercise.id) == true);
          if(index == -1) break;
          trainingPlanState[index].list?.remove(exercise.id);
          trainingPlanState.reportUpdate(trainingPlanState[index]);
        }
      }

      if(context.mounted) {
        showSnackMessage(context, removeResult ? localization.removedSuccess : localization.removeError, removeResult);
      }
    } finally {
      if(mounted) setState(() => isDeleting = false);
    }
  }
}


