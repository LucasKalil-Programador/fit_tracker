/* 
CREATE TABLE tag(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
)
*/

import 'package:fittrackr/database/entities/base_entity.dart';

class Tag implements BaseEntity{
  int? id;
  final String name;

  Tag({
    this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'Tag(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tag && other.id == this.id && other.name == this.name;

  }

  static Tag fromMap(Map<String, Object?> e) {
    return Tag(
      id: e['id'] as int,
      name: e['name'] as String,
    );
  }
}
