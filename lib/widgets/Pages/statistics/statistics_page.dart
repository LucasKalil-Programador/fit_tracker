import 'package:fittrackr/database/entities/report.dart';
import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/states/report_state.dart';
import 'package:fittrackr/states/report_table_state.dart';
import 'package:fittrackr/widgets/Pages/statistics/report_table_view.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets/forms/report_form.dart';
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
                  child: dropDownTableSelect(tableState, reportState),
                ),
                activatedTable != null
                    ? ReportView(
                      key: ValueKey(activatedTable!.id! + reports!.length.toString()),
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
          showAddModalBottom(context);
        },
      ),
    );
  }

  DropdownMenu<String?> dropDownTableSelect(ReportTableState tableState, ReportState reportState) {
    return DropdownMenu<String?>(
                  width: double.infinity,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "new", label: "Criar nova tabela"),
                    for(int i = 0; i < tableState.length; i++)
                      DropdownMenuEntry(value: tableState[i].id, label: tableState[i].name),
                  ],
                  onSelected: (value) {
                    if(value != null) {
                      if(value == "new") {
                        setState(() {
                          activatedTable = null;
                          reports = null;
                        });
                        // TODO: create table
                        return;
                      } else {
                        loadReports(tableState, reportState, value);
                      }
                    }
                  },
                );
  }

  void loadReports(ReportTableState tableState, ReportState reportState, String tableId) {
    setState(() {
      activatedTable = tableState.getById(tableId);
      reports = reportState.getByTable(
        activatedTable!.id!,
      );
    });
  }

  void showAddModalBottom(BuildContext context) {
    if (activatedTable != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(16)
              .copyWith(bottom: MediaQuery
              .of(context).viewInsets.bottom),
            child: ReportForm(
              table: activatedTable!,
              onSubmit: (report) {
                Navigator.pop(context);
                final reportTableState = Provider.of<ReportTableState>(context, listen: false);
                final reportState = Provider.of<ReportState>(context, listen: false);
                reportState.add(report);
                if(activatedTable != null)
                  loadReports(reportTableState, reportState, activatedTable!.id!);
                showSnackMessage(context, "Adicionado com sucesso!", true);
              },
            ),
          );
        },
      );
    } else {
      showSnackMessage(context, "Selecione uma tabela", false);
    }
  }
}
