import 'package:fittrackr/database/entities/base_entity.dart';

class ReportTable implements BaseEntity {
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
        other.id == this.id &&
        other.name == this.name &&
        other.description == this.description &&
        other.valueSuffix == this.valueSuffix && 
        other.createdAt == this.createdAt &&
        other.updatedAt == this.updatedAt;
  }
  
  @override
  int get hashCode => Object.hash(id, name, description, valueSuffix, createdAt, updatedAt);

  @override
  Map<String, Object?> toJson() {
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
    final updatedAt = map["updatedAt"];

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