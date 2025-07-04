import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/widgets/Pages/statistics/statistics_widgets.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late final localization = AppLocalizations.of(context)!;
  List<Report>? reports;
  ReportTable? activatedTable;
  String? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.progressStats,
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
                deleteAndEditButton(),
                activatedTable != null
                    ? ReportView(
                      key: ValueKey(activatedTable!.id! + reports!.length.toString()),
                      reports: reports,
                      table: activatedTable,
                      onDelete: onDeleteReport,
                    )
                    : ReportView(reports: null, table: null),
              ],
            ); 
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showReportForm(context),
      ),
    );
  }

  Widget deleteAndEditButton() {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: activatedTable != null ? null : Colors.grey,
              ),
              onPressed: onEditTable,
              label: Text(localization.edit),
              icon: Icon(Icons.edit),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    activatedTable != null ? colorScheme.errorContainer : Colors.grey,
              ),
              onPressed: onDeleteTable,
              label: Text(
                localization.delete,
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
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
          label: Text(localization.selectOrCreateTable),
          width: constraints.maxWidth,
          dropdownMenuEntries: [
            DropdownMenuEntry<String>(value: "new", label: localization.createNewTable),
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
              showReportTableForm(context);
              return;
            } else {
              if (value != null) {
                loadReports(tableState, reportState, value);
              }
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

// Forms

  void showReportForm(BuildContext context) {
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
              onSubmit: (report) => onCreateReport(context, report),
            ),
          );
        },
      );
    } else {
      showSnackMessage(context, localization.selectTable, false);
    }
  }

  void showReportTableForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16)
            .copyWith(bottom: MediaQuery
            .of(context).viewInsets.bottom),
            child: ReportTableForm(
              onSubmit: (table) => onCreateTable(context, table),
            ),
        );
      },
    );
  }

// Actions table

  void onCreateTable(BuildContext context, ReportTable table) {
    Navigator.pop(context);
    final reportTableState = Provider.of<ReportTableState>(context, listen: false);
    final reportState = Provider.of<ReportState>(context, listen: false);
    reportTableState.add(table);
    activatedTable = table;
    selectedId = table.id;
    
    loadReports(reportTableState, reportState, activatedTable!.id!);
    showSnackMessage(context, localization.addedSuccess, true);
  }

  void onDeleteTable() {
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

      showSnackMessage(context, localization.deletedSuccess, true);
    } else {
      showSnackMessage(context, localization.selectTable, false);
    }
  }

  void onEditTable() {
    if(activatedTable != null) {
      // TODO: editar tabela
    } else {
      showSnackMessage(context, localization.selectTable, false);
    }
  }

// Actions report

  void onCreateReport(BuildContext context, Report report) {
    Navigator.pop(context);
    final reportTableState = Provider.of<ReportTableState>(context, listen: false);
    final reportState = Provider.of<ReportState>(context, listen: false);
    reportState.add(report);
    if(activatedTable != null) {
      loadReports(reportTableState, reportState, activatedTable!.id!);
    }
    showSnackMessage(context, localization.addedSuccess, true);
  }

  void onDeleteReport(Report r) {
    final reportState = Provider.of<ReportState>(context, listen: false);
    setState(() {
      reportState.remove(r);
      if(reports != null) reports!.remove(r);
    });
    showSnackMessage(context, localization.removedSuccess, true);
  }
}
