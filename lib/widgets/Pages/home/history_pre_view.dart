import 'dart:math';
import 'package:fittrackr/database/entities/training_history.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPreView extends StatelessWidget {
  const HistoryPreView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(4),
      decoration: boxDecorator(Theme.of(context).colorScheme.primaryContainer),
      child: Consumer<TrainingHistoryState>(
        builder: (context, trainingPlanState, child) {
          final sorted = trainingPlanState.sorted();
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                decoration: boxDecorator(Theme.of(context).colorScheme.onSecondary),
                child: ListTile(
                  title: Text(localization.trainingHistory),
                  trailing: IconButton(onPressed: onShowHistory, icon: Icon(Icons.arrow_forward_ios)),
                ),
              ),
              listView(sorted, localization),
            ],
          );
        },
      ),
    );
  }

  Widget listView(List<TrainingHistory> sorted, AppLocalizations localization) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sorted.isEmpty ? 1 : min(3, sorted.length),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: boxDecorator(Theme.of(context).colorScheme.onPrimary),
          child: 
          sorted.isEmpty ? 
          ListTile(
            title: Text(localization.noTrainingRecorded, style: const TextStyle(fontWeight: FontWeight.bold)),
          ) : 
          ListTile(
            title: Text(sorted[index].trainingName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(formatDate(sorted[index].dateTime)),
          )
        );
      },
    );
  }

  void onShowHistory() {

  }

  BoxDecoration boxDecorator(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    );
  }

  String formatDate(int dateTimeMs) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(dateTimeMs);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final day = twoDigits(dateTime.day);
    final month = twoDigits(dateTime.month);
    final year = twoDigits(dateTime.year);
    final hour = twoDigits(dateTime.hour);
    final minute = twoDigits(dateTime.minute);
    
    return "$day/$month/$year $hour:$minute";
  }
}


