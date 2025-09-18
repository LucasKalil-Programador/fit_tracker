import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/widgets/Pages/config/config_widget.dart';
import 'package:fittrackr/widgets/Pages/config/google_widget.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.settings,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<MetadataState>(
        builder: (context, metadataState, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                VersionWidget(),
                DefaultDivider(),
                ThemeSelection(
                  initialValue: getTheme(metadataState),
                  onThemeSelected: (theme) => onThemeSelected(context, theme),
                ),
                DefaultDivider(),
                LocateSelector(
                  selectedLocale: getLocale(metadataState),
                  onLocaleSelected: (locale) => onLocaleSelected(context, locale),
                ),
                DefaultDivider(),
                GoogleLoginWidget(),
                DefaultDivider(),
                if(kDebugMode)
                  DevTools(),
                if(kDebugMode)
                  DefaultDivider(),
              ],
            ),
          );
        },
      ),
    );
  }

  AppTheme getTheme(MetadataState metadataState) {
    final selectedTheme = metadataState.get(themeKey);
    final themeNameMap = AppTheme.values.asNameMap();

    if(selectedTheme != null && themeNameMap.containsKey(selectedTheme)) {
      return AppTheme.values.byName(selectedTheme);
    }
    return AppTheme.system;
  }

  String getLocale(MetadataState metadataState) {
    return metadataState.get(localeKey) ?? "sys";
  }

  void onThemeSelected(BuildContext context, AppTheme theme) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.put(themeKey, theme.name);
  }

  void onLocaleSelected(BuildContext context, Locale locale) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.put(localeKey, locale.languageCode); 
  }
}


