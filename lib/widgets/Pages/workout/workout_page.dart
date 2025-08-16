import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_history.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/widgets/Pages/workout/training_plan_form.dart';
import 'package:fittrackr/widgets/Pages/workout/workout_widgets.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late AppLocalizations localization;

  bool isSubmitting = false;
  bool isDeleting = false;
  bool savingHistory = false;

  @override
  void initState() {
    super.initState();

    loadActivated();
    loadDoneList();
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.workout,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          DefaultDivider(),
          Expanded(
            child: Consumer<TrainingPlanState>(
              builder: (context, trainingPlanState, child) {
                if (trainingPlanState.isEmpty) {
                  return emptyPlanText();
                } else if (activatedPlan != null) {
                  return TrainingPlanWidget(trainingPlan: activatedPlan!, donelist: donelist, onDoneChange: saveDoneList);
                }
                return listViewTrainingPlan(trainingPlanState);
              },
            ),
          ), 
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (activatedPlan == null) {
                  showEditModalBottom(context);
                } else {
                  onFinishPlan();
                }
              },
              child: Text(activatedPlan == null ? localization.createPlanButton : localization.finishPlan),
            ),
          ),
        ],
      ),
    );
  }

  void onFinishPlan() {
    if(activatedPlan != null && donelist != null && donelist!.isNotEmpty) {
      final exercisesState = Provider.of<ExercisesState>(context, listen: false);
      final exercises = donelist!
        .map((id) => exercisesState.getById(id))
        .where((element) => element != null)
        .cast<Exercise>().toList();

      TrainingHistory history = TrainingHistory.fromTrainingPlan(
        plan: activatedPlan!,
        exercises: exercises,
        dateTime: DateTime.now().millisecondsSinceEpoch,
      );
      saveHistory(history);
    }
    
    setState(() {
      activatedPlan = null;
      donelist = null;
    });
    saveActivated(null);
    saveDoneList(null);
  }

  Future<void> saveHistory(TrainingHistory history) async {
    if (savingHistory) return;
    setState(() => savingHistory = true);

    try {
      final historyState = Provider.of<TrainingHistoryState>(context, listen: false);
      final success = await historyState.addWait(history);

      if(mounted) {
        showSnackMessage(context, success ? localization.trainingFinishedHistorySaved : localization.trainingFinishedHistorySaveError, success);
      }
    } finally {
      setState(() => savingHistory = false);
    }
  }

  Widget listViewTrainingPlan(TrainingPlanState trainingPlanState) {
    return TrainingPlanListView(
      trainingPlanState: trainingPlanState, 
      onStart: (plan) {
        setState(() {
          activatedPlan = plan;
        });
        saveActivated(plan);
      },
      onDelete: (plan) => isDeleting ? null : onDelete(plan),
      onEdit: (plan) => showEditModalBottom(context, plan, TrainingPlanFormMode.edit),
    );
  }

  void onDelete(TrainingPlan plan) async {
    if(isDeleting) return;
    setState(() => isDeleting = true);
    
    try {
      final trainingPlanState = Provider.of<TrainingPlanState>(context, listen: false);
      final removeResult = await trainingPlanState.remove(plan);
      
      if(mounted) {
        showSnackMessage(context, removeResult ? localization.removedSuccess : localization.removeError, removeResult);
      }
    } finally {
      if(mounted) setState(() => isDeleting = false);
    }
  }

  Widget emptyPlanText() {
    return Center(
      child: Text(
        style: const TextStyle(fontWeight: FontWeight.bold),
        localization.noPlansMessage,
        textAlign: TextAlign.center,
      ),
    );
  }

  void showEditModalBottom(BuildContext context, [TrainingPlan? baseTrainingPlan, int mode = TrainingPlanFormMode.creation]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16,).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: TrainingPlanForm(
            baseTrainingPlan: baseTrainingPlan,
            mode: mode,
            onSubmit: (newPlan) => isSubmitting ? null : onSubmit(newPlan, mode),
          ),
        );
      },
    );
  }

  void onSubmit(TrainingPlan newPlan, int mode) async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);

    try {
      final plansState = Provider.of<TrainingPlanState>(context, listen: false);
      bool success = false;

      if (mode == TrainingPlanFormMode.creation) {
        success = await plansState.addWait(newPlan);
      } else if (newPlan.id != null) {
        success = await plansState.reportUpdate(newPlan);
      }

      if (mounted) {
        showSnackMessage(
          context,
          success
            ? (mode == TrainingPlanFormMode.creation
                ? localization.addedSuccess
                : localization.editedSuccess)
            : (mode == TrainingPlanFormMode.creation
                ? localization.addError
                : localization.editError),
          success,
        );

        if (success) Navigator.pop(context);
      }
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  TrainingPlan? activatedPlan;
  List<String>? donelist;

  void saveActivated(TrainingPlan? plan) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.put(metadataActivatedKey, plan == null ? 'null' : plan.id!);
  }

  void saveDoneList(List<String>? donelist) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.putList(metadataDoneKey, donelist ?? List.empty());
    this.donelist = donelist;
  }

  void loadActivated() {
    final trainingPlanState = Provider.of<TrainingPlanState>(context, listen: false);
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    if(metadataState.containsKey(metadataActivatedKey)) {
      final activatedPlanId = metadataState.get(metadataActivatedKey)!;
      final index = trainingPlanState.indexWhere((plan) => plan.id == activatedPlanId);
      if(index >= 0) activatedPlan = trainingPlanState.get(index);
    }
  }

  void loadDoneList() {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    if(metadataState.containsKey(metadataDoneKey)) {
      final donelist = metadataState.getList(metadataDoneKey);
      if(donelist != null) this.donelist = donelist;
    }
  }
}