import 'dart:async';

import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:sqflite/sqflite.dart';

class ReportTableHelper implements Helper<ReportTable, String> {
  @override
  Future<void> insert(ReportTable table) async {
    final db = await DatabaseHelper().database;
    await db.insert('report_table', {
      'uuid': table.id,
      'name': table.name,
      'description': table.description,
      'value_suffix': table.valueSuffix,
      'created_at': table.createdAt,
      'updated_at': table.updatedAt
    });
  }

  @override
  Future<void> insertAll(List<ReportTable> tables) async {
    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var table in tables) {
        batch.insert('report_table', {
          'uuid': table.id,
          'name': table.name,
          'description': table.description,
          'value_suffix': table.valueSuffix,
          'created_at': table.createdAt,
          'updated_at': table.updatedAt
        });
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> upsert(ReportTable table) async {
    final db = await DatabaseHelper().database;
    await db.insert('report_table', {
      'uuid': table.id,
      'name': table.name,
      'description': table.description,
      'value_suffix': table.valueSuffix,
      'created_at': table.createdAt,
      'updated_at': table.updatedAt
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> update(ReportTable table) async {
    final db = await DatabaseHelper().database;
    await db.update('report_table', {
      'name': table.name,
      'description': table.description,
      'value_suffix': table.valueSuffix,
      'created_at': table.createdAt,
      'updated_at': table.updatedAt
    },
    where: 'uuid = ?',
    whereArgs: [table.id],
    );
  }

  @override
  Future<void> delete(ReportTable table) async {
    final db = await DatabaseHelper().database;
    await db.delete('report_table', where: 'uuid = ?', whereArgs: [table.id]);
  }

  @override
  Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('report_table');
  }

  @override
  Future<List<ReportTable>> selectAll() async {
    final db = await DatabaseHelper().database;
    final data = await db.queryCursor('report_table');

    final List<ReportTable> tables = [];
    while(await data.moveNext()) {
      final element = data.current;
      final table = ReportTable.fromMap(element);
      if(table != null) {
        tables.add(table);
      }
    }

    return tables;
  }

  @override
  Future<bool> existsById(String id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'report_table',
      where: 'uuid = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
