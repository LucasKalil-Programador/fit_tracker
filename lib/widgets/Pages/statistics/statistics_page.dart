import 'package:fittrackr/database/entities/report.dart';
import 'package:fittrackr/database/entities/report_table.dart';
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
  List<Report>? reports;
  ReportTable? activatedTable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Progresso & Estatistica",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer2<ReportTableState, ReportState>(
          builder: (context, tableState, reportState, child) {     
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: DropdownMenu<String?>(
                    width: double.infinity,
                    dropdownMenuEntries: [
                      for(int i = 0; i < tableState.length; i++)
                        DropdownMenuEntry(value: tableState[i].id, label: tableState[i].name),
                    ],
                    onSelected: (value) {
                      if(value != null) {
                        setState(() {
                          activatedTable = tableState.getById(value);
                          reports = reportState.getByTable(activatedTable!.id!);
                        });
                      }
                    },
                  ),
                ),
                activatedTable != null
                    ? ReportView(
                      key: ValueKey(activatedTable!.id!),
                      reports: reports,
                      table: activatedTable,
                    )
                    : ReportView(reports: null, table: null)
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

        },
      ),
    );
  }
}
