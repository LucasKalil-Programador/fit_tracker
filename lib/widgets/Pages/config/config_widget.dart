import 'dart:io';

import 'package:fittrackr/database/generate_db.dart';
import 'package:fittrackr/main.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/utils/importer_exporter.dart';
import 'package:flutter/material.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
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
    final localization = AppLocalizations.of(context)!;
    Map<AppTheme, String> themeTextMap = {AppTheme.dark: localization.dark, AppTheme.light: localization.light, AppTheme.system: localization.system};
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(localization.theme, style: Theme.of(context).textTheme.titleLarge),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: AppTheme.values.length,
          itemBuilder: (context, index) {
            final item = AppTheme.values[index];
            final String text =
                themeTextMap.containsKey(item) ? themeTextMap[item]! : localization.defaultOption;
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

// Locale Selector

class LocateSelector extends StatelessWidget {
  final String selectedLocale;
  final Function(Locale locale) onLocaleSelected;

  const LocateSelector({super.key, required this.selectedLocale, required this.onLocaleSelected});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Center(child: Text(localization.languageTitle, style: Theme.of(context).textTheme.titleLarge)),
        LayoutBuilder(builder: (context, constraints) => 
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DropdownMenu(
                initialSelection: selectedLocale,
                width: constraints.maxWidth,
                dropdownMenuEntries: [
                  for (var locale in AppLocalizations.supportedLocales)
                    DropdownMenuEntry<String>(value: locale.languageCode, label: getLanguageByCode(localization, locale.languageCode)),
                  DropdownMenuEntry<String>(value: "sys", label: getLanguageByCode(localization, "sys"))
                ],
                onSelected: (value) {
                  if(value != null) {
                    onLocaleSelected(Locale(value));
                  }
                },
              )
            ),
        ),
      ],
    );
  }

  String getLanguageByCode(AppLocalizations localization, String languageCode) {
    switch (languageCode) {
      case "pt":
        return localization.portugueseLanguage;
      case "en":
        return localization.englishLanguage;
      default:
        return localization.system;
    }
  }
}

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

class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    String platform = "unknown";
    if(Platform.isAndroid) {
      platform = "Android";
    } else if(Platform.isIOS) {
      platform = "IOS";
    } else if(Platform.isWindows) {
      platform = "Windows";
    }
    
    return Text(localization.appVersionPlatform(version, platform), style: TextStyle(fontWeight: FontWeight.bold),);
  }
}