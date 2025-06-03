import 'package:fittrackr/database/generate_db.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/widgets/Pages/config/config_widget.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Configurações",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<MetadataState>(
        builder: (context, metadataState, child) {
          return Column(
            children: [
              DefaultDivider(),
              ThemeSelection(
                initialValue: getTheme(metadataState),
                onThemeSelected: (theme) => onThemeSelected(context, theme),
              ),
              DefaultDivider(),
              DevTools(),
              DefaultDivider(),
            ],
          );
        },
      ),
    );
  }

  AppTheme getTheme(MetadataState metadataState) {
    final selectedTheme = metadataState.get(themeKey);
    if(selectedTheme != null) {
      return AppTheme.values.byName(selectedTheme);
    }
    return AppTheme.system;
  }

  void onThemeSelected(BuildContext context, AppTheme theme) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.put(themeKey, theme.name);
  }
}

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
              child: Text("Limpar TODOS os dados", softWrap: false,),
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
              child: Text("Gerar dados de demonstração"),
            ),
            iconAlignment: IconAlignment.start,
          ),
        ),
      ],
    );
  }

  Future<void> onClear(BuildContext context) async {
    final eState = Provider.of<ExercisesState>(context, listen: false);
    final pState = Provider.of<TrainingPlanState>(context, listen: false);
    final rState = Provider.of<ReportState>(context, listen: false);
    final tState = Provider.of<ReportTableState>(context, listen: false);
    await eState.clear();
    await pState.clear();
    await rState.clear();
    await tState.clear();
  }

  Future<void> onGenerate(BuildContext context) async {
    final eState = Provider.of<ExercisesState>(context, listen: false);
    final pState = Provider.of<TrainingPlanState>(context, listen: false);
    final rState = Provider.of<ReportState>(context, listen: false);
    final tState = Provider.of<ReportTableState>(context, listen: false);
    await generateDB(eState, pState, tState, rState);
  }
}