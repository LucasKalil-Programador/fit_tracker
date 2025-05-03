import 'dart:convert';

import 'package:fittrackr/database/entities/base_entity.dart';

class TrainingPlan implements BaseEntity{
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
    return 'TrainingPlan(id: $id, name: $name, list: ${this.list})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainingPlan && other.id == this.id && other.name == this.name;
  }

  @override
  int get hashCode => Object.hash(id, name);

  @override
  Map<String, Object?> toJson() {
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
}
