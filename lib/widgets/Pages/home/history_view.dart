import 'dart:math';

import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/training_history.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryCard extends StatefulWidget {
  final TrainingHistory? history;
  final BoxDecoration? boxDecoration;
  final bool showMore;
  final Widget? trailing;

  const HistoryCard({super.key, this.boxDecoration, this.history, this.trailing, this.showMore = false});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  late AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;

    Widget tile;
    List<Widget> widgets = [];
    int animationSpeed = 100;

    if(widget.history == null) {
      tile = ListTile(
        title: Text(localization.noTrainingRecorded, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
    } else {
      tile = ListTile(
        title: Text(widget.history!.trainingName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(formatDate(context, widget.history!.dateTime)),
        trailing: widget.trailing,
      );
      if(widget.showMore) {
        for (var i = 0; i < widget.history!.exercises.length; i++) {
          widgets.add(exerciseWidget(widget.history!.exercises[i], i));
        }
      }
      animationSpeed *= widget.history!.exercises.length;
    }
    
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: widget.boxDecoration,
      child: 
      Column(
        children: [
          tile,
          AnimatedSize(
            duration: Duration(milliseconds: animationSpeed),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            ),
          ),
        ],
      )
    );
  }

  Padding exerciseWidget(ExerciseSnapshot exercise, int index) {
    final typeStr =
        exercise.type == ExerciseType.musclework.name
            ? localization.kg
            : localization.minutes;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        title: Text(exercise.name),
        leading: Text("$index", style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          "${exercise.sets}x${exercise.reps}   ${exercise.amount} $typeStr",
        ),
      ),
    );
  }

  String formatDate(BuildContext context, int dateTimeMs) {
    final locale = Localizations.localeOf(context).toString();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(dateTimeMs);
    final formattedDate = DateFormat.yMMMMd(locale).add_Hm().format(dateTime);
    return formattedDate;
  }
}


class HistoryListView extends StatefulWidget {
  final BoxDecoration? boxDecoration;
  final List<TrainingHistory> histories;
  final ScrollPhysics? physics;
  final int? maxCards;


  const HistoryListView({
    super.key,
    this.boxDecoration,
    this.maxCards,
    this.physics,
    required this.histories
  });

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  final List<int> showMoreIndexes = [];

  @override
  Widget build(BuildContext context) {
    var itemCount = widget.histories.isEmpty ? 1 : widget.histories.length;
    if(widget.maxCards != null && widget.histories.isNotEmpty) itemCount = min(itemCount, widget.maxCards!);

    return ListView.builder(
      physics: widget.physics,
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return HistoryCard(
          boxDecoration: widget.boxDecoration,
          history: widget.histories.isEmpty ? null : widget.histories[index],
          trailing: IconButton(
            onPressed: () => onShowMore(index),
            icon: Icon(
              showMoreIndexes.contains(index)
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_left,
            ),
          ),
          showMore: showMoreIndexes.contains(index),
        );
      },
    );
  }

  void onShowMore(int index) {
    setState(() {
      if(showMoreIndexes.contains(index)) {
        showMoreIndexes.remove(index);
      } else {
        showMoreIndexes.add(index);
      }
    });
  }
}


class HistoryFullList extends StatelessWidget {
  final List<TrainingHistory> histories;
  final BoxDecoration? boxDecoration;

  const HistoryFullList({super.key, this.boxDecoration, required this.histories});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.trainingHistory,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: HistoryListView(
        histories: histories,
        boxDecoration: boxDecoration,
      ),
    );
  }
}


class HistoryPreView extends StatelessWidget {
  const HistoryPreView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(4),
      decoration: historyCardBoxDecorator(Theme.of(context).colorScheme.primaryContainer),
      child: Consumer<TrainingHistoryState>(
        builder: (context, trainingPlanState, child) {
          final sorted = trainingPlanState.sorted();
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(4),
                decoration: historyCardBoxDecorator(Theme.of(context).colorScheme.onSecondary),
                child: ListTile(
                  title: Text(localization.trainingHistory),
                  trailing: IconButton(onPressed: () => onShowHistory(context, sorted), icon: Icon(Icons.arrow_forward_ios)),
                ),
              ),
              HistoryListView(
                histories: sorted,
                maxCards: 3,
                physics: const NeverScrollableScrollPhysics(),
                boxDecoration: historyCardBoxDecorator(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void onShowHistory(BuildContext context, List<TrainingHistory> sorted) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: HistoryFullList(
            histories: sorted,
            boxDecoration: historyCardBoxDecorator(
              Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        );
      },
    );
  }
}

BoxDecoration historyCardBoxDecorator(Color color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
    ],
  );
}




