// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities/metadata.dart';
import 'package:sqflite/sqflite.dart';

mixin MetadataHelper {
  Future<int> insertMetadata(Metadata metadata) async {
    final db = await (this as DatabaseHelper).database;
    metadata.id = await db.insert('metadata', {
      'key': metadata.key,
      'value': metadata.value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    return metadata.id!;
  }

  Future<int> deleteMetadata(Metadata metadata) async {
    final db = await (this as DatabaseHelper).database;
    return await db.delete('metadata', where: 'id = ?', whereArgs: [metadata.id]);
  }
  
  Future<int> updateMetadata(Metadata metadata) async {
    final db = await (this as DatabaseHelper).database;
    return db.update(
      'metadata',
      {'key': metadata.key, 'value': metadata.value},
      where: 'id = ?',
      whereArgs: [metadata.id],
    );
  }

  Future<List<Metadata>> selectAllMetadata() async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('metadata');
    return result.map(Metadata.fromMap).toList();
  }

  Future<Metadata?> selectMetadata(int id) async {
    final db = await (this as DatabaseHelper).database;
    final result = await db.query('metadata', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Metadata.fromMap(result.first) : null;
  }
}
