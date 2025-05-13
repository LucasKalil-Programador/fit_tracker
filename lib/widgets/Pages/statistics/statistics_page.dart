import 'package:fittrackr/database/entities/report.dart';
import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/states/report_state.dart';
import 'package:fittrackr/states/report_table_state.dart';
import 'package:fittrackr/widgets/Pages/statistics/report_table_view.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:fittrackr/widgets/forms/report_form.dart';
import 'package:fittrackr/widgets/forms/report_table_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}
// TODO: editar tabela
// TODO: deletar valores

class _StatisticsPageState extends State<StatisticsPage> {
  List<Report>? reports;
  ReportTable? activatedTable;

  String? selectedId;

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
                  child: dropDownTableSelect(tableState, reportState)
                ),
                DeleteAndEditButton(),
                activatedTable != null
                    ? ReportView(
                      key: ValueKey(activatedTable!.id! + reports!.length.toString()),
                      reports: reports,
                      table: activatedTable,
                    )
                    : ReportView(reports: null, table: null),
              ],
            ); 
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showReportFormModalBottom(context);
        },
      ),
    );
  }

  Row DeleteAndEditButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: activatedTable != null ? null : Colors.grey,
              ),
              onPressed: onEditButton,
              label: const Text("Editar"),
              icon: Icon(Icons.edit),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    activatedTable != null ? Colors.red : Colors.grey,
              ),
              onPressed: onDeleteButton,
              label: const Text("Deletar"),
              icon: Icon(Icons.delete),
            ),
          ),
        ),
      ],
    );
  }

  Widget dropDownTableSelect(ReportTableState tableState, ReportState reportState) {
    return LayoutBuilder(builder: (context, constraints) {
        return DropdownMenu<String?>(
          initialSelection: selectedId,
          label: const Text("Selecione uma tabela ou crie uma"),
          width: constraints.maxWidth,
          dropdownMenuEntries: [
            DropdownMenuEntry<String>(value: "new", label: "Criar nova tabela"),
            for (int i = 0; i < tableState.length; i++)
              DropdownMenuEntry<String>(
                value: tableState[i].id!,
                label: tableState[i].name,
              ),
          ],
          onSelected: (value) {
            selectedId = value;
            if (value == "new") {
              setState(() {
                activatedTable = null;
                reports = null;
              });
              showReportTableFormModalBottom(context);
              return;
            } else {
          if (value != null) loadReports(tableState, reportState, value);
            }
          },
        );
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

  void onDeleteButton() {
    if(activatedTable != null) {
      final tableState = Provider.of<ReportTableState>(context, listen: false);
      final reportState = Provider.of<ReportState>(context, listen: false);
      final reportList = reportState.getByTable(activatedTable!.id!);
      for (var element in reportList) {
        reportState.remove(element);
      }
      tableState.remove(activatedTable!);
      
      setState(() {
        activatedTable = null;
        reports = null;
      });

      showSnackMessage(context, "Deletado com sucesso", true);
    } else {
      showSnackMessage(context, "Selecione uma tabela", false);
    }
  }

  void onEditButton() {
    if(activatedTable != null) {
      // TODO: editar tabela
    } else {
      showSnackMessage(context, "Selecione uma tabela", false);
    }
  }

  void showReportFormModalBottom(BuildContext context) {
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

  void showReportTableFormModalBottom(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16)
            .copyWith(bottom: MediaQuery
            .of(context).viewInsets.bottom),
            child: ReportTableForm(
              onSubmit: (table) {
                Navigator.pop(context);
                final reportTableState = Provider.of<ReportTableState>(context, listen: false);
                final reportState = Provider.of<ReportState>(context, listen: false);
                reportTableState.add(table);
                activatedTable = table;
                selectedId = table.id;
                
                loadReports(reportTableState, reportState, activatedTable!.id!);
                showSnackMessage(context, "Adicionado com sucesso!", true);
              },
            ),
        );
      },
    );
  }
}

