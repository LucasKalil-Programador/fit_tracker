import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AppTheme {dark, light, system}

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
          final selectedTheme = metadataState.get(themeKey);
          AppTheme theme = AppTheme.system;
          if(selectedTheme != null) {
            theme = AppTheme.values.byName(selectedTheme);
          }
          
          return Column(
            children: [
              DefaultDivider(),
              ThemeSelection(
                initialValue: theme,
                onThemeSelected: (theme) => onThemeSelected(context, theme),
              ),
              DefaultDivider(),
            ],
          );
        },
      ),
    );
  }

  void onThemeSelected(BuildContext context, AppTheme theme) {
    final metadataState = Provider.of<MetadataState>(context, listen: false);
    metadataState.put(themeKey, theme.name);
  }
}


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
