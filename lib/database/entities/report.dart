import 'package:fittrackr/database/entities/base_entity.dart';

class Report implements BaseEntity {
  String? id;
  final String note;
  final int reportDate;
  final int value;
  final String tableId;

  Report({
    this.id,
    required this.note,
    required this.reportDate,
    required this.value,
    required this.tableId
  });

  @override
  String toString() {
    return 'Report(id: $id, note: $note, reportDate: $reportDate, value: $value, tableId: $tableId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Report &&
        other.id == this.id &&
        other.note == this.note &&
        other.reportDate == this.reportDate &&
        other.value == this.value &&
        other.tableId == this.tableId;
  }

  @override
  int get hashCode => Object.hash(id, note, reportDate, value, tableId);

  @override
  Map<String, Object?> toJson() {
    return {
      "uuid": id,
      "note": note,
      "report_date": reportDate,
      "value": value,
      "table_id": tableId,
    };
  }

  static Report? fromMap(Map<String, Object?> map) {
    final uuid = map["uuid"];
    final note = map["note"];
    final reportDate = map["report_date"];
    final value = map["value"];
    final tableId = map["table_id"];

    if (uuid is String    && note is String &&
        reportDate is int && value is int   && tableId is String) {
      return Report(
        id: uuid,
        note: note,
        reportDate: reportDate,
        value: value,
        tableId: tableId,
      );
    }

    return null;
  }
}
