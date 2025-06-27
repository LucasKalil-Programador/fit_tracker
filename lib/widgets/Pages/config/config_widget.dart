import 'package:fittrackr/database/generate_db.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/utils/importer_exporter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// Theme Selector

enum AppTheme {dark, light, system}

class ThemeSelection extends StatefulWidget {
  final AppTheme initialValue;
  final Function(AppTheme theme)? onThemeSelected;

  const ThemeSelection({super.key, this.onThemeSelected, required this.initialValue});

  @override
  State<ThemeSelection> createState() => _ThemeSelectionState();
}

class _ThemeSelectionState extends State<ThemeSelection> {
  AppTheme? selectedTheme;

  @override
  void initState() {
    super.initState();

    selectedTheme = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    Map<AppTheme, String> themeTextMap = {AppTheme.dark: "Escuro", AppTheme.light: "Claro", AppTheme.system: "Sistema"};
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Tema", style: Theme.of(context).textTheme.titleLarge),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: AppTheme.values.length,
          itemBuilder: (context, index) {
            final item = AppTheme.values[index];
            final String text =
                themeTextMap.containsKey(item) ? themeTextMap[item]! : "Default";
            return ListTile(
              title: Text(text),
              leading: Radio<AppTheme>(
                value: item,
                groupValue: selectedTheme,
                onChanged: (theme) {
                  setState(() {
                    selectedTheme = theme;
                  });
                  if(theme != null && widget.onThemeSelected != null) {
                    widget.onThemeSelected!(theme);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// Dev Tools

class DevTools extends StatelessWidget {
  const DevTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Center(child: Text("Dev tools", style: Theme.of(context).textTheme.titleLarge)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton.icon(
            onPressed: () async => onClear(context),
            icon: Icon(Icons.clear),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Limpar TODOS os dados", softWrap: false),
            ),
            iconAlignment: IconAlignment.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton.icon(
            onPressed: () async => onGenerate(context),
            icon: Icon(Icons.developer_mode),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Gerar dados de demonstração", softWrap: false),
            ),
            iconAlignment: IconAlignment.start,
          ),
        ),
      ],
    );
  }

  Future<void> onClear(BuildContext context) async {
    clearContext(context);
  }

  Future<void> onGenerate(BuildContext context) async {
    final eState = Provider.of<ExercisesState>(context, listen: false);
    final pState = Provider.of<TrainingPlanState>(context, listen: false);
    final rState = Provider.of<ReportState>(context, listen: false);
    final tState = Provider.of<ReportTableState>(context, listen: false);
    await generateDB(eState, pState, tState, rState);
  }
}