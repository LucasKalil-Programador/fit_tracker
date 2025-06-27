
// BaseEntity

import 'dart:convert';

abstract class BaseEntity {
  String? id;

  Map<String, Object?> toMap();

  bool get isValid;
}

// Exercise

enum ExerciseType {cardio, musclework}

class Exercise implements BaseEntity {
  @override
  String? id;
  final String name;
  final int amount;
  final int reps;
  final int sets;
  final ExerciseType type;

  Exercise({
    this.id,
    required this.name,
    required this.amount,
    required this.reps,
    required this.sets,
    required this.type,
  });

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, amount: $amount, reps: $reps, sets: $sets, type: ${type.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.reps == reps &&
        other.sets == sets &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(id, name, amount, reps, sets, type);

  @override
  Map<String, Object?> toMap() {
    return {
      "uuid": id,
      "name": name,
      "amount": amount,
      "reps": reps,
      "sets": sets,
      "type": type.name
    };
  }

  static Exercise? fromMap(Map<String, Object?> e) {
    final uuid = e["uuid"];
    final name = e["name"];
    final amount = e["amount"];
    final reps = e["reps"];
    final sets = e["sets"];
    final type = e["type"];
    if(uuid is String && name is String && amount is int && 
       reps is int    && sets is int    && type is String) {
      return Exercise(
        id: uuid,
        name: name,
        amount: amount,
        reps: reps,
        sets: sets,
        type: ExerciseType.values.byName(type),
      );
    }

    return null;
  }
  
  @override
  // TODO: implement isValid
  bool get isValid => true;
}

// ReportTable

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
  
  @override
  // TODO: implement isValid
  bool get isValid => true;
}

// Report

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
  
  @override
  // TODO: implement isValid
  bool get isValid => true;
}

// TrainingPlan

class TrainingPlan implements BaseEntity {
  @override
  String? id;
  final String name;
  late List<String>? list;

  TrainingPlan({
    this.id,
    required this.name, 
    this.list,
  });

  @override
  String toString() {
    return 'TrainingPlan(id: $id, name: $name, list: $list)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainingPlan && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);

  @override
  Map<String, Object?> toMap() {
    return {
      "uuid": id,
      "name": name,
      "list": jsonEncode(list),
    };
  }

  static TrainingPlan? fromMap(Map<String, Object?> e) {
    final uuid = e['uuid'];
    final name = e['name'];
    final list = e['list'];

    if (uuid is String && name is String && list is String) {
      return TrainingPlan(
        id: uuid,
        name: name,
        list: List<String>.from(jsonDecode(list)),
      );
    }
    return null;
  }
  
  @override
  // TODO: implement isValid
  bool get isValid => true;
}