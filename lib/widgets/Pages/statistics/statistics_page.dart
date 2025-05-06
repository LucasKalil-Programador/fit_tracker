import 'package:fittrackr/states/report_state.dart';
import 'package:fittrackr/states/report_table_state.dart';
import 'package:fittrackr/widgets/Pages/statistics/report_table_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Progresso & Estatistica",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer2<ReportTableState, ReportState>(
        builder: (context, tableState, reportState, child) {
          final table = tableState.first;
          final reports = reportState.getByTable(table.id!);
          return ReportView(reports: reports, table: table);
        },
      ),
    );
  }
}
