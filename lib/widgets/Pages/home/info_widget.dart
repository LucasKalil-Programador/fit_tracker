import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/widgets/Pages/home/calendar.dart';
import 'package:fittrackr/widgets/Pages/home/history_view.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowMoreButton extends StatelessWidget {
  const ShowMoreButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return ElevatedButton.icon(
      onPressed: () => onShowMoreInfo(context),
      label: Text(localization.moreInfo),
      icon: Icon(Icons.info),
    );
  }

  void onShowMoreInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const InfoWidget(),
        );
      },
    );
  }
}

class InfoWidget extends StatefulWidget {
  const InfoWidget({
    super.key,
  });

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  late int day, month, year;

  _InfoWidgetState() {
    final now = DateTime.now();
    day = now.day;
    month = now.month;
    year = now.year;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.moreInfo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<TrainingHistoryState>(
        builder: (context, history, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Calendar(
                  day: day,
                  month: month,
                  year: year,
                  checkActivity: history.hasHistoryInDate,
                  onDateClick: (day, month, year) {
                    setState(() {
                      this.day = day;
                      this.month = month;
                      this.year = year;
                    });
                  },
                ),
                DefaultDivider(),
                HistoryListView(
                  histories: history.getHistoryInDate(day, month, year),
                  physics: const NeverScrollableScrollPhysics(),
                  boxDecoration: historyCardBoxDecorator(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
