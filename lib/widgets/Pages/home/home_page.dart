import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/widgets/Pages/home/home_page_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final void Function(int)? onChangePage;

  const HomePage({super.key, this.onChangePage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.homeAppBar,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ShowCurrentActivePlan(onClick: () => widget.onChangePage!(2))
          ],
        ),
      ),
    );
  }
}
