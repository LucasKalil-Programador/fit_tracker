import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Sequence extends StatelessWidget {
  const Sequence({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingHistoryState>(
      builder:
          (context, history, widget) => Column(
            children: [
              Text("Sequência atual: ${getActualSequence(history)} dias",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              WeeklySummary(weekActivit: getActivitList(history)),
            ],
          ),
    );
  }

  int getActualSequence(TrainingHistoryState history) {
    int sequence = 0;
    while(true) {
      final today = DateTime.now().subtract(Duration(days: sequence));
      final result = history.any((e) => isSameDate(DateTime.fromMillisecondsSinceEpoch(e.dateTime), today));
      if(result) {
        sequence++;
      } else {
        break;
      }
    }
    return sequence;
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day;
  }

  List<bool> getActivitList(TrainingHistoryState history) {
    final weekActivit = <bool>[];
    final nowWeekday = DateTime.now().weekday + 1;
    for (var i = nowWeekday; i >= 1; i--) {
      final weekDay = getDateForWeekday(i).day;
      final result = history.any((e) => DateTime.fromMillisecondsSinceEpoch(e.dateTime).day == weekDay);
      weekActivit.add(result);
    }
    return weekActivit.reversed.toList();
  }

  DateTime getDateForWeekday(int weekday) {
    if (weekday < 1 || weekday > 7) {
      return DateTime.now();
    }

    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    int currentIndex = (currentWeekday % 7) + 1;

    int difference = weekday - currentIndex;
    return now.add(Duration(days: difference));
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
    final daysOfWeek = const ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];
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
                  child: daySummary(weekActivit.length > i ? weekActivit[i] : false, daysOfWeek[i]),
                ),
              ),
          ],
        );
      }
    );
  }

  Widget daySummary(bool light, String dayOfWeek, {double scale = 1.0}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.translate(offset: Offset(20 * scale, 0), child: SvgPicture.asset(light ? Assets.fireLight : Assets.fireDark, width: 200 * scale, height: 200 * scale)),
          Text(dayOfWeek, style: TextStyle(fontSize: 54 * scale), textAlign: TextAlign.center)
        ],
      );
  }
}
