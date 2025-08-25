import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:fittrackr/widgets/Pages/home/history_view.dart';
import 'package:fittrackr/widgets/Pages/home/current_active_view.dart';
import 'package:fittrackr/widgets/Pages/home/sequence.dart';
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShowCurrentActivePlan(onClick: () => widget.onChangePage!(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 48),
              child: const Sequence(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const HistoryPreView(),
            ),
          ],
        ),
      ),
    );
  }
}
