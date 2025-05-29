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
              DataInputOutput(),
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

class DataInputOutput extends StatelessWidget {
  const DataInputOutput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Text("Dados", style: Theme.of(context).textTheme.titleLarge),
        ElevatedButton.icon(
          onPressed: onExport,
          icon: Icon(Icons.file_upload),
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Exportar dados"),
          ),
        ),
        ElevatedButton.icon(
          onPressed: onImport,
          icon: Icon(Icons.file_download),
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Importar dados"),
          ),
          iconAlignment: IconAlignment.start,
        ),
        ElevatedButton.icon(
          onPressed: () => onGenerate(context),
          icon: Icon(Icons.developer_mode),
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Gerar dados de demonstração"),
          ),
          iconAlignment: IconAlignment.start,
        ),
      ],
    );
  }

  void onExport() {
    // TODO: onExport
  }

  void onImport() {
    // TODO: onImport
  }

  void onGenerate(BuildContext context) {
    final eState = Provider.of<ExercisesState>(context, listen: false);
    final pState = Provider.of<TrainingPlanState>(context, listen: false);
    final rState = Provider.of<ReportState>(context, listen: false);
    final tState = Provider.of<ReportTableState>(context, listen: false);
    generateDB(eState, pState, tState, rState);
  }
}