import 'dart:io';

import 'package:fittrackr/database/generate_db.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/main.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/utils/importer_exporter.dart';
import 'package:fittrackr/widgets/common/request_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dev Tools

class DevTools extends StatelessWidget {
  const DevTools({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Center(child: Text(localization.devTools, style: Theme.of(context).textTheme.titleLarge)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton.icon(
            onPressed: () async => onClear(context),
            icon: Icon(Icons.clear),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(localization.clearAllData, softWrap: false),
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
              child: Text(localization.generateDemoData, softWrap: false),
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

// Version

class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final mode = kDebugMode ? "Debug" : "Release";
    String platform = "unknown";

    if(Platform.isAndroid) {
      platform = "Android";
    } else if(Platform.isIOS) {
      platform = "IOS";
    } else if(Platform.isWindows) {
      platform = "Windows";
    }
    
    return Text(localization.appVersionPlatform(version, platform, mode), style: TextStyle(fontWeight: FontWeight.bold),);
  }
}

// Account deletion


class AccountDeletionButton extends StatelessWidget {
  final bool isLogged;
  final VoidCallback onConfirmDeletion;

  const AccountDeletionButton({
    super.key,
    required this.isLogged,
    required this.onConfirmDeletion,
  });

  void _showConfirmationDialog(BuildContext context, AppLocalizations localization) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 10),
            Text(localization.attention),
          ],
        ),
        content: Text(
          localization.deleteAccountWarning,
          style: TextStyle(height: 1.5),
        ),
        actions: [
          RequestButtons(
                onPressed: (result) {
                  Navigator.of(context).pop();
                  if (result) {
                    onConfirmDeletion();
                  }
                },
                waitTimeSeconds: 10,
                messageText: "",
                rejectText: localization.cancel,
                acceptText: localization.deleteAccount,
                acceptButtonColor: Colors.red,
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton.icon(
        onPressed: isLogged
            ? () => _showConfirmationDialog(context, localization)
            : null,
        icon: const Icon(Icons.delete),
        label: Text(localization.deleteAccount),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}