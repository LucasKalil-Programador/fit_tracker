import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/utils/assets.dart';
import 'package:fittrackr/widgets/Pages/home/info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
              Text(localization.currentStreak(getActualSequence(history, context)),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              WeeklySummary(weekActivit: getActivitList(history)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowMoreButton(),
                  IconButton(onPressed: () => onShowEditPanel(context), icon: Icon(Icons.edit)),
                ],
              )
            ],
          ),
    );
  }

  void onShowEditPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(
            16,
          ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditPanel(),
        );
      },
    );
  }

  int getActualSequence(TrainingHistoryState history, BuildContext context) {
    final now = DateTime.now();
    final firstDate = history.firstDateTime();
    final metadata = Provider.of<MetadataState>(context);
    final activeDays = metadata.getList(sequencePreferenceKey)?.map(int.parse).toList();
    
    int offset = 0;
    int sequence = 0;

    while(true) {
      final day = now.subtract(Duration(days: offset));
      final hasHistory = history.hasHistoryInDate(day.day, day.month, day.year);
      final isRelevant = activeDays != null && activeDays.contains((day.weekday % 7) + 1);
    
      if(hasHistory) {
        sequence++;
        offset++;
      } else if(isRelevant) {
        break;
      } else {
        offset++;
      }

      if(firstDate != null && day.isBefore(firstDate)) {
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


class EditPanel extends StatefulWidget {
  const EditPanel({
    super.key,
  });

  @override
  State<EditPanel> createState() => _EditPanelState();
}

class _EditPanelState extends State<EditPanel> {
  bool isSaving = false;
  final activeDays = <int>[];

  @override
  void initState() {
    super.initState();

    final metadata = Provider.of<MetadataState>(context, listen: false);
    final list = metadata.getList(sequencePreferenceKey);
    if(list != null) {
      final days = list.map(int.tryParse).where((e) => e != null).cast<int>().toList();
      activeDays.addAll(days);
    } else {
      for (var i = 0; i < 7; i++) {
        activeDays.add(i);
      }
    }
  }
  
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(localization.selectTrainingDays),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Text(localization.selectedDaysInfo),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < daysOfWeek.length; i++)
                Column(
                  children: [
                    Text(daysOfWeek[i]),
                    Checkbox(
                      value: activeDays.contains((i % 7) + 1),
                      onChanged: (value) => onCheckDay((i % 7) + 1),
                    ),
                  ],
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 64),
            child: ElevatedButton(onPressed: onSave, child: Text(localization.save)),
          ),
        ],
      ),
    );
  }

  void onCheckDay(int i) {
    return setState(() {
      if (activeDays.contains(i)) {
        activeDays.remove(i);
      } else {
        activeDays.add(i);
      }
    });
  }

  void onSave() {
    if (isSaving) return;
    isSaving = true;
    
    try {
      final metadata = Provider.of<MetadataState>(context, listen: false);
      final dayList = activeDays.map((e) => e.toString()).toList();
      metadata.putList(sequencePreferenceKey, dayList);
      Navigator.pop(context);
    } finally {
      isSaving = false;
    }
  }
}

