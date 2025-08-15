import 'dart:async';

import 'package:fittrackr/database/helper/helper.dart';
import 'package:sqflite/sqflite.dart';

class MetadataHelper implements Helper<MapEntry<String, String>, String> {
  @override
  Future<void> insert(MapEntry<String, String> metadata) async {
    final db = await DatabaseHelper().database;
    await db.insert('metadata', {
      'key': metadata.key,
      'value': metadata.value,
    });
  }

  @override
  Future<void> insertAll(List<MapEntry<String, String>> metadataList) async {
    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var metadata in metadataList) {
        batch.insert('metadata', {
          'key': metadata.key,
          'value': metadata.value,
        });
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> upsert(MapEntry<String, String> metadata) async {
    final db = await DatabaseHelper().database;
    await db.insert('metadata', {
      'key': metadata.key,
      'value': metadata.value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> update(MapEntry<String, String> metadata) async {
    final db = await DatabaseHelper().database;
    await db.update('metadata', {
      'value': metadata.value,
      },
      where: 'key = ?',
      whereArgs: [metadata.key],
    );
  }

  @override
  Future<void> delete(MapEntry<String, String> metadata) async {
    final db = await DatabaseHelper().database;
    await db.delete('metadata', where: 'key = ?', whereArgs: [metadata.key]);
  }

  @override
  Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('metadata');
  }

  @override
  Future<List<MapEntry<String, String>>> selectAll() async {
    final db = await DatabaseHelper().database;
    final data = await db.queryCursor('metadata');

    final List<MapEntry<String, String>> metadata = [];
    while (await data.moveNext()) {
      final element = data.current;
      final key = element["key"];
      final value = element["value"];
      if(key is String && value is String) {
        metadata.add(MapEntry(key, value));
      }
    }
    
    return metadata;
  }
  
  @override
  Future<bool> existsById(String key) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'metadata',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
