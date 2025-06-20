import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
              DataImportExport(),
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


class DataImportExport extends StatelessWidget {
  const DataImportExport({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Center(child: Text("Dados", style: Theme.of(context).textTheme.titleLarge)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton.icon(
            onPressed: onExport,
            icon: Icon(Icons.file_upload),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Exportar dados", softWrap: false),
            ),
            iconAlignment: IconAlignment.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton.icon(
            onPressed: () => onImport(context),
            icon: Icon(Icons.file_download),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Importar dados", softWrap: false),
            ),
            iconAlignment: IconAlignment.start,
          ),
        ),
      ],
    );
  }

  void onImport(context) async {
    final eState = Provider.of<ExercisesState>(context, listen: false);
    final pState = Provider.of<TrainingPlanState>(context, listen: false);
    final rState = Provider.of<ReportState>(context, listen: false);
    final tState = Provider.of<ReportTableState>(context, listen: false);
    final output = {
      "Exercises": eState.toJson(),
      "Plans":     pState.toJson(),
      "Table":     tState.toJson(),
      "Reports":   rState.toJson(),
    };
    final json = jsonEncode(output);
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/fittracker_backup.json");
    await file.writeAsString(json);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: "fittracker backup")
    );
  }

  void onExport() {
    // TODO: onExport
  }
}