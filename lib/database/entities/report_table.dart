import 'package:fittrackr/database/entities/entity.dart';

class ReportTable implements BaseEntity {
  @override
  String? id;
  final String name;
  final String description;
  final String valueSuffix;
  final int createdAt;
  final int updatedAt;

  ReportTable({
    this.id,
    required this.name,
    required this.description,
    required this.valueSuffix,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'ReportTable(id: $id, name: $name, description: $description, valueSuffix: $valueSuffix, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReportTable &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.valueSuffix == valueSuffix && 
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
  
  @override
  int get hashCode => Object.hash(id, name, description, valueSuffix, createdAt, updatedAt);

  @override
  Map<String, Object?> toMap() {
    return {
      "uuid": id,
      "name": name,
      "description": description,
      "value_suffix": valueSuffix,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  static ReportTable? fromMap(Map<String, Object?> map) {
    final uuid = map["uuid"];
    final name = map["name"];
    final description = map["description"];
    final valueSuffix = map["value_suffix"];
    final createdAt = map["created_at"];
    final updatedAt = map["updated_at"];

    if (uuid is String        && name is String   && description is String &&
        valueSuffix is String && createdAt is int && updatedAt is int) {
      return ReportTable(
        id: uuid,
        name: name,
        description: description,
        valueSuffix: valueSuffix,
        createdAt: createdAt,
        updatedAt: updatedAt
      );
    }

    return null;
  }
}

class Report implements BaseEntity {
  @override
  String? id;
  final String note;
  final int reportDate;
  final double value;
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
        other.id == id &&
        other.note == note &&
        other.reportDate == reportDate &&
        other.value == value &&
        other.tableId == tableId;
  }

  @override
  int get hashCode => Object.hash(id, note, reportDate, value, tableId);

  @override
  Map<String, Object?> toMap() {
    return {
      "uuid": id,
      "note": note,
      "report_date": reportDate,
      "value": value,
      "report_table_uuid": tableId,
    };
  }

  static Report? fromMap(Map<String, Object?> map) {
    final uuid = map["uuid"];
    final note = map["note"];
    final reportDate = map["report_date"];
    final value = map["value"];
    final tableId = map["report_table_uuid"];

    if (uuid is String    && note is String &&
        reportDate is int && value is double   && tableId is String) {
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
