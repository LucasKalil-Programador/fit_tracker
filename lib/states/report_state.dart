import 'package:fittrackr/database/entities/report.dart';
import 'package:fittrackr/states/base_list_state.dart';

class ReportState extends BaseListState<Report> {
  List<Report> getByTable(String tableId) {
    return where((e) => e.tableId == tableId)
    .toList();
  }
}