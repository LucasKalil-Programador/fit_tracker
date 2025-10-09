import 'package:diacritic/diacritic.dart';
import 'package:fittrackr/Controllers/exercise/exercise_controller.dart';
import 'package:fittrackr/Models/exercise.dart';
import 'package:fittrackr/Providers/common/search_controller.dart';
import 'package:fittrackr/Providers/exercise_form.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets_v2/Pages/exercise_list_form.dart';
import 'package:fittrackr/widgets_v2/Pages/exercise_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseListPageV2 extends ConsumerWidget {
  final widgetID = "exercise page";

  const ExerciseListPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesList = ref.watch(exerciseControllerProvider);
    final searchStr = ref.watch(searchControllerProvider(id: widgetID));
    final localization = AppLocalizations.of(context)!;

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
              onChanged: (search) => onSearchChange(ref, search)
            ),
          ),
          Expanded(
            child: ExerciseListView(
              sortedList: search(searchStr, exercisesList),
              onDelete: (exercise) => onDelete(ref, exercise),
              onEdit: (exercise) => onEdit(ref, exercise),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAdd(ref),
        child: Icon(Icons.add),
      ),
    );
  }

  void onAdd(WidgetRef ref) {
    showEditModalBottom(ref);
  }

  void onDelete(WidgetRef ref, Exercise exercise) {
    if(exercise.id == null) return;
    ref.read(exerciseControllerProvider.notifier)
      .removeById(exercise.id!);
  }

  void onEdit(WidgetRef ref, Exercise exercise) {
    if(exercise.id == null) return;
    showEditModalBottom(ref, exercise);
  }

  void onSearchChange(WidgetRef ref, String search) {
    ref
        .read(searchControllerProvider(id: widgetID).notifier)
        .set(search);
  }

  void showEditModalBottom(WidgetRef ref, [Exercise? baseExercise]) {
    final mode = baseExercise == null ? ExerciseFormMode.creation : ExerciseFormMode.edit;

    if(baseExercise != null) {
      final controller = ref.read(exerciseFormControllerProvider);
      final data = controller.copyWith(
        type: baseExercise.type,
        amount: baseExercise.amount,
        name: baseExercise.name,
        reps: baseExercise.reps,
        sets: baseExercise.sets
      );
      ref.read(exerciseFormControllerProvider.notifier).update(data);
    }
    
    showModalBottomSheet(
      context: ref.context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ExerciseForm(
            onSubmit: (newExercise) => onSubmit(ref, newExercise, mode),
            mode: mode,
            baseExercise: baseExercise,
          ),
        );
      },
    ).then((_) {
      if(mode == ExerciseFormMode.edit) {
        ref.read(exerciseFormControllerProvider.notifier).clear();
      }
    },);
  }

  void onSubmit(WidgetRef ref, Exercise newExercise, ExerciseFormMode mode) {
    final localization = AppLocalizations.of(ref.context)!;
    
    bool success = false;
    if(mode == ExerciseFormMode.creation) {
      ref.read(exerciseControllerProvider.notifier).add(newExercise);
      
      ref.read(exerciseFormControllerProvider.notifier).clear();
      success = true;
    } else if(newExercise.id != null) {
      ref.read(exerciseControllerProvider.notifier).updateById(newExercise.id!, newExercise);
      success = true;
    }
    
    showSnackMessage(
      ref.context,
      success
          ? (mode == ExerciseFormMode.creation
              ? localization.addedSuccess
              : localization.editedSuccess)
          : (mode == ExerciseFormMode.creation
              ? localization.addError
              : localization.editError),
      success,
    );

    if (success) Navigator.pop(ref.context);
  }

  List<Exercise> search(String searchStr, List<Exercise> input) {
    return input.where((e) => _searchFilter(e, _normalize(searchStr))).toList();
  }

  String _normalize(String str) => removeDiacritics(str).toLowerCase();

  bool _searchFilter(Exercise exercise, String searchStr) {
    return _normalize(exercise.name).contains(searchStr) || 
           _normalize(exercise.category).contains(searchStr) ||
           [exercise.reps, exercise.amount, exercise.sets].contains(int.tryParse(searchStr));
  }
}