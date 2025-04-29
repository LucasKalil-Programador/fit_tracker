import 'dart:async';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/states/training_plan_state.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets/common/timer_widget.dart';
import 'package:fittrackr/widgets/common/training_plan_widget.dart';
import 'package:fittrackr/widgets/forms/exercise_plan_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {

  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final metadataActivatedKey = "workout:activated";
  final metadataTimeKey = "workout:timer";
  Timer? timerSaveDebounce;
  Timer? activSaveDebounce;
  
  TrainingPlan? activatedPlan;
  TimerData? timerData;

  @override
  void initState() {
    super.initState();
    
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    if (metadataState.contains(metadataTimeKey)) {
      final data = metadataState[metadataTimeKey]!.split(",");
      if(data.length == 3) {
        timerData = TimerData(
          startTime: DateTime.tryParse(data[0]),
          pausedTime: DateTime.tryParse(data[1]),
          paused: bool.parse(data[2]),
        );
      }
    }

    if(metadataState.contains(metadataActivatedKey)) {
      final data = metadataState[metadataActivatedKey]!;
      final activatedPlanId = int.tryParse(data);
      if(activatedPlanId != null) {
        final trainingPlanState = Provider.of<TrainingPlanState>(context, listen: false);
        activatedPlan = trainingPlanState.getById(activatedPlanId);
      }
    }
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
          timer_widget(),
          DefaultDivider(),
          Expanded(
            child: Consumer<TrainingPlanState>(
              builder: (context, trainingPlanState, child) {
                if (trainingPlanState.plans.isEmpty) 
                  return emptyPlanText();
                if (activatedPlan != null)
                  return TrainingPlanWidget(trainingPlan: activatedPlan!);
                return listTrainingPlan(trainingPlanState);
              },
            ),
          ), 
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (activatedPlan == null) {
                  _showEditModalBottom(context);
                } else {
                  setState(() {
                    activatedPlan = null;
                  });
                  _saveActivated(null);
                }
              },
              child: Text(activatedPlan == null ? "Criar plano" : "Finalizar plano"),
            ),
          ),
        ],
      ),
    );
  }

  Widget listTrainingPlan(TrainingPlanState trainingPlanState) {
    return ListView.builder(
      itemCount: trainingPlanState.plans.length,
      itemBuilder: (context, index) {
        final plan = trainingPlanState.plans[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: TrainingPlanCard(
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
                      _saveActivated(plan);
                    },
                    child: const Icon(Icons.play_arrow),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {},
                  child: const Icon(Icons.edit),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveActivated(TrainingPlan? plan) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    activSaveDebounce?.cancel();
    activSaveDebounce = Timer(Duration(seconds: 1), () {
      unawaited(metadataState.set(metadataActivatedKey, plan == null ? 'null' : plan.id.toString()));
    });
  }

  Widget emptyPlanText() {
    return Center(
      child: Text(
        style: TextStyle(fontWeight: FontWeight.bold),
        "Você ainda não tem nenhum plano de treino. \nToque em 'Criar plano' para começar.",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget timer_widget() {
    return TimerWidget(
      onTimerChanged: (timerData) {
        setState(() {
          this.timerData = timerData;
        });
        _saveTimer(timerData);
      },
      timerData: timerData,
    );
  }

  void _saveTimer(TimerData timerData) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    final value = "${timerData.startTime?.toIso8601String()},${timerData.pausedTime?.toIso8601String()},${timerData.paused}";
    timerSaveDebounce?.cancel();
    timerSaveDebounce = Timer(Duration(seconds: 1), () {
      unawaited(metadataState.set(metadataTimeKey, value));
    });
  }

  void _showEditModalBottom(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(
            16,
          ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: TrainingPlanForm(
            onSubmit: (e) {
              Navigator.pop(context);

              TrainingPlanState plansState = Provider.of<TrainingPlanState>(context, listen: false);
              plansState.add(e);
              if(e.list != null && e.list!.isNotEmpty) {
                DatabaseHelper().setPlanExerciseList(e, e.list!);
              }

              showSnackMessage(context, "Adicionado com sucesso!", true);
            },
          ),
        );
      },
    );
  }
}
