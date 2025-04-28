import 'dart:async';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/metadata.dart';
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
  final metadataActivatedKey = "workout:Activated";
  final metadataTimeKey = "workout:timer";
  Timer? timerSaveDelay;
  TimerData? timerData;

  @override
  void initState() {
    super.initState();
    print("initState");
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    if (metadataState.contains(metadataTimeKey)) {
      final Metadata metadata = metadataState[metadataTimeKey]!;
      final data = metadata.value.split(",");
      timerData = TimerData(
        startTime: data[0] == "null" ? null : DateTime.parse(data[0]),
        pausedTime: data[1] == "null" ? null : DateTime.parse(data[1]),
        paused: bool.parse(data[2]),
      );
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
              builder: (context, exercisePlanState, child) {
                if (exercisePlanState.plans.isEmpty)
                  return Center(
                    child: Text(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      "Você ainda não tem nenhum plano de treino. \nToque em 'Criar plano' para começar.",
                      textAlign: TextAlign.center,
                    ),
                  );
                
                final metadataState = Provider.of<MetadataState>(context, listen: false);
                if(!metadataState.contains(metadataActivatedKey)) {
                  final activated = exercisePlanState.plans.last;
                  activated.loadList();
                  return TrainingPlanWidget(trainingPlan: activated);
                } else {
                  return Text("Nenhum treino ativo");
                }
              },
            ),
          ), 
          Center(
            child: ElevatedButton(
              onPressed: () => _showEditModalBottom(context),
              child: Text("Criar plano"),
            ),
          ),
        ],
      ),
    );
  }

  Widget timer_widget() {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    return TimerWidget(
      onTimerChanged: (timerData) {
        final value = "${timerData.startTime?.toIso8601String()},${timerData.pausedTime?.toIso8601String()},${timerData.paused}";
        final metadata = Metadata(
          id: metadataState[metadataTimeKey]?.id,
          key: metadataTimeKey,
          value: value,
        );

        setState(() {
          this.timerData = timerData;
        });
        timerSaveDelay?.cancel();
        timerSaveDelay = Timer(Duration(seconds: 1), () {
          unawaited(metadataState.set(metadata));
        });
      },
      timerData: timerData,
    );
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

  
