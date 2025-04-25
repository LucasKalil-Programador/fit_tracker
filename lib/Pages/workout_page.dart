import 'package:fittrackr/entities/exercise_plan.dart';
import 'package:fittrackr/state/exercise_plan_state.dart';
import 'package:fittrackr/state/timer_state.dart';
import 'package:fittrackr/widgets/default_widgets.dart';
import 'package:fittrackr/widgets/forms/exercise_plan_form.dart';
import 'package:fittrackr/widgets/exercise_plan_widget.dart';
import 'package:fittrackr/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  

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
          Consumer<TimerState>(
            builder: (context, timerState, child) => TimerWidget(timerState: timerState),
          ),
          DefaultDivider(),
          Expanded(
            child: Consumer<ExercisePlanState>(
              builder: (context, exercisePlanState, child) {
                ExercisePlan? plan = exercisePlanState.getActivated();
                if (exercisePlanState.planList.isEmpty)
                  return Center(
                    child: Text(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      "Você ainda não tem nenhum plano de treino. \nToque em 'Criar plano' para começar.",
                      textAlign: TextAlign.center,
                    ),
                  );
                return ExercisePlanWidget(exercisePlan: plan);
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => showEditModalBottom(context),
              child: Text("Criar plano"),
            ),
          ),
        ],
      ),
    );
  }

    void showEditModalBottom(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ExercisePlanForm(onSubmit: (e) {
            Navigator.pop(context);

            ExercisePlanState exercisePlanState = Provider.of<ExercisePlanState>(context, listen: false);
            exercisePlanState.addExercise(e);
            exercisePlanState.activated = e.id;

            showSnackMessage(context, "Adicionado com sucesso!", true);
          }),
        );
      },
    );
  } 
}
