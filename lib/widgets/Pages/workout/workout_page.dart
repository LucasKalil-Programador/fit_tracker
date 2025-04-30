import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/states/training_plan_state.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets/Pages/workout/timer_widget.dart';
import 'package:fittrackr/widgets/Pages/workout/training_plan_widget.dart';
import 'package:fittrackr/widgets/forms/training_plan_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  @override
  void initState() {
    super.initState();

    loadActivated();
    loadDoneList();
    loadTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Treino",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          DefaultDivider(),
          timerWidget(),
          DefaultDivider(),
          Expanded(
            child: Consumer<TrainingPlanState>(
              builder: (context, trainingPlanState, child) {
                if (trainingPlanState.isEmpty) 
                  return emptyPlanText();
                if (activatedPlan != null)
                  return TrainingPlanWidget(trainingPlan: activatedPlan!, donelist: donelist, onDoneChange: saveDoneList,);
                return listTrainingPlan(trainingPlanState);
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
              child: Text(activatedPlan == null ? "Criar plano" : "Finalizar plano"),
            ),
          ),
        ],
      ),
    );
  }


  static const  metadataActivatedKey = "workout:activated";
  static const  metadataDoneKey = "workout:donelist";
  TrainingPlan? activatedPlan;
  List<String>? donelist;

  Widget listTrainingPlan(TrainingPlanState trainingPlanState) {
    return ListView.builder(
      itemCount: trainingPlanState.length,
      itemBuilder: (context, index) {
        final plan = trainingPlanState[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: DefaultTrainingPlanCard(
            plan: plan,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        activatedPlan = plan;
                      });
                      saveActivated(plan);
                    },
                    child: const Icon(Icons.play_arrow),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    showEditModalBottom(context, plan, TrainingPlanFormMode.edit);
                  },
                  child: const Icon(Icons.edit),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveActivated(TrainingPlan? plan) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.put(metadataActivatedKey, plan == null ? 'null' : plan.id!);
  }

  void saveDoneList(List<String>? donelist) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.putList(metadataDoneKey, donelist == null ? List.empty() : donelist);
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


  static const metadataTimeKey = "workout:timer";
  TimerData? timerData;

  Widget timerWidget() {
    return TimerWidget(
      onTimerChanged: (timerData) {
        setState(() {
          this.timerData = timerData;
        });
        saveTimer(timerData);
      },
      timerData: timerData,
    );
  }

  void saveTimer(TimerData timerData) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    final value = {
      "start_time": timerData.startTime?.millisecondsSinceEpoch,
      "paused_time": timerData.pausedTime?.millisecondsSinceEpoch,
      "paused": timerData.paused,
    };
    metadataState.putMap(metadataTimeKey, value);
  }

  void loadTimer() {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    final data = metadataState.getMap(metadataTimeKey);
    if(data != null) {
      timerData = TimerData(
        startTime: data["start_time"] is int ? DateTime.fromMillisecondsSinceEpoch(data["start_time"] as int) : null,
        pausedTime: data["paused_time"] is int ? DateTime.fromMillisecondsSinceEpoch(data["paused_time"] as int) : null,
        paused: data["paused"] == true,
      );
    }
  }


  Widget emptyPlanText() {
    return Center(
      child: Text(
        style: const TextStyle(fontWeight: FontWeight.bold),
        "Você ainda não tem nenhum plano de treino. \nToque em 'Criar plano' para começar.",
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
          padding: EdgeInsets.all(
            16,
          ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: TrainingPlanForm(
            baseTrainingPlan: baseTrainingPlan,
            mode: mode,
            onSubmit: (newPlan) {
              Navigator.pop(context);
              TrainingPlanState plansState = Provider.of<TrainingPlanState>(context, listen: false);

              if(mode == TrainingPlanFormMode.creation) {
                plansState.add(newPlan);
                showSnackMessage(context, "Adicionado com sucesso!", true);
              } else {
                if(newPlan.id != null) {
                  int index = plansState.indexWhere((entity) => entity.id == newPlan.id);
                  
                  if(index >= 0) {
                    plansState[index] = newPlan;
                    showSnackMessage(context, "Editado com sucesso!", true);
                    return;
                  }
                }
                
                showSnackMessage(context, "Error ao editar!", false);
              }
            },
          ),
        );
      },
    );
  }
}
