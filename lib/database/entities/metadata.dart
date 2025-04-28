/* CREATE TABLE metadata(
  id INTEGER PRIMARY KEY AUTOINCREMENT
  key TEXT NOT NULL UNIQUE,
  value TEXT NOT NULL
) */

import 'package:fittrackr/database/entities/base_entity.dart';

class Metadata implements BaseEntity {
  int? id;
  final String key;
  final String value;

  Metadata({this.id, required this.key, required this.value});

  @override
  String toString() {
    return 'Metadata(id: $id, key: $key, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Metadata &&
        other.id == this.id &&
        other.key == this.key &&
        other.value == this.value;
  }

  static Metadata fromMap(Map<String, Object?> e) {
    return Metadata(
      id: e['id'] as int,
      key: e['key'] as String,
      value: e['value'] as String,
    );
  }
}