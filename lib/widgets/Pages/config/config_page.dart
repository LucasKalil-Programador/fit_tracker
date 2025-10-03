import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/widgets/Pages/config/config_widget.dart';
import 'package:fittrackr/widgets/Pages/config/google_widget.dart';
import 'package:fittrackr/widgets/Pages/config/locate_selector.dart';
import 'package:fittrackr/widgets/Pages/config/theme_selector.dart';
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
                ThemeSelector(),
                DefaultDivider(),
                LocateSelector(),
                DefaultDivider(),
                GoogleLoginWidget(),
                DefaultDivider(),
                if(kDebugMode) DevTools(),
                if(kDebugMode) DefaultDivider(),
              ],
            ),
          );
        },
      ),
    );
  }

  void onThemeSelected(BuildContext context, ThemeMode theme) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.put(themeKey, theme.name);
  }

  void onLocaleSelected(BuildContext context, Locale locale) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.put(localeKey, locale.languageCode); 
  }
}


