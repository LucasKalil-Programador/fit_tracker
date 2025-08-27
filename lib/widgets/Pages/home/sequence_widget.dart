import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/utils/assets.dart';
import 'package:fittrackr/widgets/Pages/home/history_view.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Sequence extends StatelessWidget {
  const Sequence({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    
    return Consumer<TrainingHistoryState>(
      builder:
          (context, history, widget) => Column(
            children: [
              Text(localization.currentStreak(getActualSequence(history)),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              WeeklySummary(weekActivit: getActivitList(history)),
              const SizedBox(height: 24),
              ShowMoreButton()
            ],
          ),
    );
  }

  int getActualSequence(TrainingHistoryState history) {
    final now = DateTime.now();
    int sequence = 0;

    while(true) {
      final day = now.subtract(Duration(days: sequence));
      final result = history.hasHistoryInDate(day.day, day.month, day.year);
      if(result) {
        sequence++;
      } else {
        break;
      }
    }
    return sequence;
  }

  List<bool> getActivitList(TrainingHistoryState history) {
    final now = DateTime.now();
    final weekActivit = <bool>[];

    for (var i = 0; i < (now.weekday % 7) + 1; i++) {
      final day = now.subtract(Duration(days: i));
      weekActivit.add(history.hasHistoryInDate(day.day, day.month, day.year));
    }
    return weekActivit.reversed.toList();
  }
}

class WeeklySummary extends StatelessWidget {
  final List<bool> weekActivit;

  const WeeklySummary({
    super.key,
    required this.weekActivit
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    
    final daysOfWeek = [
      localization.sun,
      localization.mon,
      localization.tue,
      localization.wed,
      localization.thu,
      localization.fri,
      localization.sat,
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = constraints.maxWidth / 7 - 4;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < daysOfWeek.length; i++)
              SizedBox(
                width: size,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: DayFire(light: weekActivit.length > i ? weekActivit[i] : false, title: daysOfWeek[i]),
                ),
              ),
          ],
        );
      }
    );
  }
}

class DayFire extends StatelessWidget {
  final double scale;
  final String title;
  final bool light;

  const DayFire({
    super.key,
    required this.light,
    required this.title,
    this.scale = 1.0
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.translate(offset: Offset(20 * scale, 0), child: SvgPicture.asset(light ? Assets.fireLight : Assets.fireDark, width: 200 * scale, height: 200 * scale)),
          Text(title, style: TextStyle(fontSize: 54 * scale), textAlign: TextAlign.center)
        ],
      );
  }
}


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


class Calendar extends StatefulWidget {
  final bool Function(int day, int month, int year)? checkActivity;
  final void Function(int day, int month, int year)? onDateClick;
  final int day, month, year;

  const Calendar({super.key, this.checkActivity, this.onDateClick, required this.day, required this.month, required this.year});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int monthOffset = 0;

  List<Widget> _buildCalendarDays(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    int startOffset = firstDayOfMonth.weekday % 7;
    int totalDays = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    for (int i = 0; i < startOffset; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= totalDays; day++) {
      bool hasResult = false;
      if(widget.checkActivity != null) {
        hasResult = widget.checkActivity!(day, date.month, date.year);
      }

      var borderColor = Theme.of(context).colorScheme.primary;
      if(widget.day == day && widget.month == date.month && widget.year == date.year) {
        borderColor = Theme.of(context).colorScheme.primaryContainer;
      }
      
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            if (widget.onDateClick != null) {
              widget.onDateClick!(day, date.month, date.year);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
              ),
              child: SizedBox(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: DayFire(light: hasResult, title: day.toString()),
                    ),
                  ),
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < 42 - (startOffset + totalDays); i++) {
      dayWidgets.add(Container());
    }

    return dayWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final localization = AppLocalizations.of(context)!;

    final date = DateTime(
      widget.year,
      widget.month - monthOffset,
      widget.day,
    );
    
    final daysOfWeek = [
      localization.sun,
      localization.mon,
      localization.tue,
      localization.wed,
      localization.thu,
      localization.fri,
      localization.sat,
    ];

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => setState(() => monthOffset++),
                icon: Icon(Icons.arrow_back_ios),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(locale).format(date),
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => monthOffset--),
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            children: daysOfWeek
                .map((day) => Center(child: Text(day, style: TextStyle(fontWeight: FontWeight.bold))))
                .toList(),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            children: _buildCalendarDays(date),
          ),
        ],
    );
  }
}



