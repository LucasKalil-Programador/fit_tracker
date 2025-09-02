import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/widgets/Pages/home/sequence_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
