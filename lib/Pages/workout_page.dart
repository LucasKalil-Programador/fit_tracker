import 'dart:math';

import 'package:fittrackr/state/exercises_list_state.dart';
import 'package:fittrackr/state/timer_state.dart';
import 'package:fittrackr/widgets/exercise_card.dart';
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
          Divider(color: Theme.of(context).colorScheme.primary, thickness: 2),
          Consumer<TimerState>(
            builder: (context, timerState, child) => TimerWidget(timerState: timerState),
          ),
          Divider(color: Theme.of(context).colorScheme.primary, thickness: 2),
        ],
      ),
    );
  }
}
