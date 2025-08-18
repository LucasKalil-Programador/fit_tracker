import 'dart:io';

import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/states/auth_state.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/utils/importer_exporter.dart';
import 'package:fittrackr/widgets/Pages/config/config_widget.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


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
                DataImportExport(),
                DefaultDivider(),
                DevTools(),
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

class GoogleLoginWidget extends StatefulWidget {

  const GoogleLoginWidget({super.key});

  @override
  State<GoogleLoginWidget> createState() => _GoogleLoginWidgetState();
}

class _GoogleLoginWidgetState extends State<GoogleLoginWidget> {
  late AppLocalizations localization;
  bool isLoading = false;
  
  // TODO: sync button

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    return Column(
      spacing: 5,
      children: [
        Center(child: Text(localization.googleAccount, style: Theme.of(context).textTheme.titleLarge)),
        Consumer(
          builder: (BuildContext context, AuthState authState, Widget? child) => details(context, authState),
        ),
        Consumer<AuthState>(
          builder: (BuildContext context, AuthState authState, Widget? child) { 
            if(authState.status == AuthStatus.authenticated) {
              return logout(context, authState);
            } else {
              return login(context, authState);
            }
           },
        ),
      ],
    );
  }

  Widget details(BuildContext context, AuthState authState) {
    if(isLoading) {
      return LoadingAnimationWidget.waveDots(color: Theme.of(context).colorScheme.secondary, size: 50);
    }
    
    if(authState.isLoggedIn) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: getUserAvatar(authState),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(localization.loginWithGoogle, textAlign: TextAlign.center,),
    );
  }

  Widget getUserAvatar(AuthState authState) {
    String? photoURL = authState.user?.photoURL;
    Widget avatar = CircleAvatar(backgroundImage: photoURL != null ? Image.network(photoURL).image : null);
    Widget userText = Text(localization.loggedInAs(authState.user?.displayName ?? localization.anonymous));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        Padding(padding: const EdgeInsets.all(8.0), child: userText),
      ],
    );
  }

  Widget login(BuildContext context, AuthState authState) {
    return ElevatedButton.icon(
      icon: Icon(Icons.login),
      label: Text(localization.login),
      onPressed: () => onLogin(authState, context),
    );
  }

  Widget logout(BuildContext context, AuthState authState) {
    return ElevatedButton.icon(
      icon: Icon(Icons.logout),
      label: Text(localization.logout),
      onPressed: () => onLogout(authState, context),
    );
  }

  Future<void> onLogin(AuthState authState, BuildContext context) async {
    if(isLoading) return;
    setState(() => isLoading = true);

    try {
      final success = await authState.signInWithGoogle();
      if(context.mounted) {
        if (success) {
          showSnackMessage(context, localization.loggedInAs(authState.user?.displayName ?? localization.anonymous), true);
        } else {
          showSnackMessage(context, localization.loginFailed, false);
        }
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> onLogout(AuthState authState, BuildContext context) async {
    if(isLoading) return;
    setState(() => isLoading = true);

    try {
      await authState.signOut();
      if(context.mounted) {
        showSnackMessage(context, localization.userLoggedOut, true);
      }
    } catch (e) {
      if(context.mounted) {
        showSnackMessage(context, localization.logoutFailed, true);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }
}

class DataImportExport extends StatelessWidget {
  const DataImportExport({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Center(child: Text(localization.data, style: Theme.of(context).textTheme.titleLarge)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton.icon(
            onPressed: () => onExport(context),
            icon: Icon(Icons.file_upload),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(localization.exportData, softWrap: false),
            ),
            iconAlignment: IconAlignment.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton.icon(
            onPressed: () => onImport(),
            icon: Icon(Icons.file_download),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(localization.importData, softWrap: false),
            ),
            iconAlignment: IconAlignment.start,
          ),
        ),
      ],
    );
  }

  void onExport(BuildContext context) async {
    final localization = AppLocalizations.of(context)!;
    final json = contextToJson(context);
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/fittracker_backup.json");
    await file.writeAsString(json);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: localization.fittrackerBackup)
    );
  }

  void onImport() {
    // TODO: onImport
  }
}