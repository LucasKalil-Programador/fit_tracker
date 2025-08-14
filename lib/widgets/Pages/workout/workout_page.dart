import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:fittrackr/widgets/Pages/workout/training_plan_form.dart';
import 'package:fittrackr/widgets/Pages/workout/workout_widgets.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late AppLocalizations localization;
  bool isDeleting = false;

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
                }
                if (activatedPlan != null) {
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
                  setState(() {
                    activatedPlan = null;
                    donelist = null;
                  });
                  saveActivated(null);
                  saveDoneList(donelist);
                }
              },
              child: Text(activatedPlan == null ? localization.createPlanButton : localization.finishPlan),
            ),
          ),
        ],
      ),
    );
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
    logger.i("Deleted");
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
            onSubmit: (newPlan) {
              Navigator.pop(context);
              TrainingPlanState plansState = Provider.of<TrainingPlanState>(context, listen: false);
              
              if(mode == TrainingPlanFormMode.creation) {
                plansState.add(newPlan);
                showSnackMessage(context, localization.addedSuccess, true);
              } else {
                if(newPlan.id != null) {
                  int index = plansState.indexWhere((entity) => entity.id == newPlan.id);
                  
                  if(index >= 0) {
                    plansState[index] = newPlan;
                    showSnackMessage(context, localization.editedSuccess, true);
                    return;
                  }
                }
                showSnackMessage(context, localization.editError, false);
              }
            },
          ),
        );
      },
    );
  }


  static const  metadataActivatedKey = "workout:activated";
  static const  metadataDoneKey = "workout:donelist";
  TrainingPlan? activatedPlan;
  List<String>? donelist;

  void saveActivated(TrainingPlan? plan) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.put(metadataActivatedKey, plan == null ? 'null' : plan.id!);
  }

  void saveDoneList(List<String>? donelist) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.putList(metadataDoneKey, donelist ?? List.empty());
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