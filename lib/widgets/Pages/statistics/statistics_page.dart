import 'package:fittrackr/database/entities.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/widgets/Pages/statistics/statistics_widgets.dart';
import 'package:fittrackr/widgets/common/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late AppLocalizations localization;
  List<Report>? reports;
  ReportTable? activatedTable;
  String? selectedId;

  bool isDeletingReport = false;
  bool isDeletingTable = false;

  bool isCreatingReport = false;
  bool isCreatingTable = false;

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
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
                      onDelete: isDeletingReport ? null : onDeleteReport,
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
              onSubmit: (report) => isCreatingReport ? null : onCreateReport(context, report),
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
              onSubmit: (table) => isCreatingTable ? null : onCreateTable(context, table),
            ),
        );
      },
    );
  }

  // Actions table

  void onCreateTable(BuildContext context, ReportTable table) async {
    if(isCreatingTable) return;
    setState(() => isCreatingTable = true);

    try {
      final reportTableState = Provider.of<ReportTableState>(context, listen: false);
      final reportState = Provider.of<ReportState>(context, listen: false);

      final success = await reportTableState.addWait(table);

      if(success) {
        activatedTable = table; 
        selectedId = table.id;
        loadReports(reportTableState, reportState, activatedTable!.id!);
      }

      if(context.mounted) {
        showSnackMessage(context, success ? localization.addedSuccess : localization.addError, success);
        if(success) Navigator.pop(context);
      }
    } finally {
      setState(() => isCreatingTable = false);
    }
  }

  void onDeleteTable() async {
    if(activatedTable != null) {
      try {
        if(isDeletingTable) return;
        setState(() => isDeletingTable = true);

        final tableState = Provider.of<ReportTableState>(context, listen: false);
        final reportState = Provider.of<ReportState>(context, listen: false);
        final reportList = reportState.getByTable(activatedTable!.id!);

        await Future.wait(reportList.map((e) => reportState.remove(e)));
        final removeResult = await tableState.remove(activatedTable!);
        
        if(mounted) {
          if(removeResult) {
            setState(() {
              activatedTable = null;
              reports = null;
            });
          }
          showSnackMessage(context, removeResult ? localization.deletedSuccess : localization.deleteError, true);
        }
      } finally {
        if(mounted) setState(() => isDeletingTable = false);
      }
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

  void onCreateReport(BuildContext context, Report report) async {
    if (isCreatingReport) return;
    setState(() => isCreatingReport = true);

    try {
      final reportTableState = Provider.of<ReportTableState>(context, listen: false);
      final reportState = Provider.of<ReportState>(context, listen: false);

      bool success = await reportState.addWait(report);

      if (success && activatedTable != null) {
        loadReports(reportTableState, reportState, activatedTable!.id!);
      }

      if (context.mounted) {
        showSnackMessage(context, success ? localization.addedSuccess : localization.addError, success,);
        if (success) Navigator.pop(context);
      }
    } finally {
      setState(() => isCreatingReport = false);
    }
  }

  void onDeleteReport(Report r) async {
    if(isDeletingReport) return;
    setState(() => isDeletingReport = true);

    try {
      final reportState = Provider.of<ReportState>(context, listen: false);
      final removeResult = await reportState.remove(r);
    
      if(mounted) {
        if(removeResult) setState(() => reports?.remove(r));
        showSnackMessage(context, removeResult ? localization.removedSuccess: localization.removeError, removeResult);
      }
    } finally {
      if(mounted) setState(() => isDeletingReport = false);
    }
  }
}
