import 'dart:async';

import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:sqflite/sqflite.dart';

class ReportHelper implements Helper<Report, String> {
  @override
  Future<void> insert(Report report) async {
    final db = await DatabaseHelper().database;
    await db.insert('report', {
      'uuid': report.id,
      'note': report.note,
      'report_date': report.reportDate,
      'value': report.value,
      'report_table_uuid': report.tableId,
    });
  }

  @override
  Future<void> insertAll(List<Report> reports) async {
    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var report in reports) {
        batch.insert('report', {
          'uuid': report.id,
          'note': report.note,
          'report_date': report.reportDate,
          'value': report.value,
          'report_table_uuid': report.tableId,
        });
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> upsert(Report report) async {
    final db = await DatabaseHelper().database;
    await db.insert('report', {
      'uuid': report.id,
      'note': report.note,
      'report_date': report.reportDate,
      'value': report.value,
      'report_table_uuid': report.tableId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> update(Report report) async {
    final db = await DatabaseHelper().database;
    await db.update('report', {
      'uuid': report.id,
      'note': report.note,
      'report_date': report.reportDate,
      'value': report.value,
      'report_table_uuid': report.tableId,
    },
    where: 'uuid = ?',
    whereArgs: [report.id],
    );
  }

  @override
  Future<void> delete(Report report) async {
    final db = await DatabaseHelper().database;
    await db.delete('report', where: 'uuid = ?', whereArgs: [report.id]);
  }

  @override
  Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('report');
  }

  @override
  Future<List<Report>> selectAll() async {
    final db = await DatabaseHelper().database;
    final data = await db.queryCursor('report');

    final List<Report> tables = [];
    while(await data.moveNext()) {
      final element = data.current;
      final table = Report.fromMap(element);
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
      'report',
      where: 'uuid = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
