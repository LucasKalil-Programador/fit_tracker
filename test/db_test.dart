
import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  reportTest();
  exerciseTest();
  metadataTest();
  reportTableTest();
  trainingPlanTest();
}

void reportTest() {
  test('Report insert test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    await proxy.reportTable.insert(reportTable);

    final report = Report(id: Uuid().v4(), note: "Semana-0", reportDate: 1256, value: 110, tableId: reportTable.id!);
    await proxy.report.insert(report);

    final proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report), true);
  });
  
  test('Report insert error same id', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    await proxy.reportTable.insert(reportTable);

    final report1 = Report(id: Uuid().v4(), note: "Semana-0", reportDate: 1256, value: 110, tableId: reportTable.id!);
    await proxy.report.insert(report1);

    final report2 = Report(id: report1.id, note: "Semana-1", reportDate: 12561, value: 1101, tableId: reportTable.id!);
    await proxy.report.insert(report2, printLog: false);

    final proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report1), true);
    expect(proxyResult.result?.contains(report2), false);
  });
  
  test('Report delete test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    await proxy.reportTable.insert(reportTable);

    final report = Report(id: Uuid().v4(), note: "Semana-0", reportDate: 1256, value: 110, tableId: reportTable.id!);
    await proxy.report.insert(report);

    var proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report), true);

    await proxy.report.delete(report);
    proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report), false);
  });

  test('Report delete all test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    await proxy.reportTable.insert(reportTable);

    final report = Report(id: Uuid().v4(), note: "Semana-0", reportDate: 1256, value: 110, tableId: reportTable.id!);
    await proxy.report.insert(report);

    var proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report), true);

    await proxy.report.deleteAll();
    proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.isEmpty, true);
  });
  
  test('Report update test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    await proxy.reportTable.insert(reportTable);

    final report = Report(id: Uuid().v4(), note: "Semana-0", reportDate: 1256, value: 110, tableId: reportTable.id!);
    await proxy.report.insert(report);

    var proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report), true);

    final reportNew = Report(id: report.id, note: "Semana-1", reportDate: 125611, value: 11012, tableId: reportTable.id!);

    await proxy.report.update(reportNew);
    proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(reportNew), true);
    expect(proxyResult.result?.contains(report), false);
  });
  
  test('Report select all test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    await proxy.reportTable.insert(reportTable);

    final report1 = Report(id: Uuid().v4(), note: "Semana-1", reportDate: 12561, value: 11011111, tableId: reportTable.id!);
    final report2 = Report(id: Uuid().v4(), note: "Semana-2", reportDate: 125622, value: 1102222, tableId: reportTable.id!);
    final report3 = Report(id: Uuid().v4(), note: "Semana-3", reportDate: 1256333, value: 110333, tableId: reportTable.id!);
    final report4 = Report(id: Uuid().v4(), note: "Semana-4", reportDate: 12564444, value: 11044, tableId: reportTable.id!);
    final report5 = Report(id: Uuid().v4(), note: "Semana-5", reportDate: 125655555, value: 1105, tableId: reportTable.id!);
    await proxy.report.insert(report1);
    await proxy.report.insert(report2);
    await proxy.report.insert(report3);
    await proxy.report.insert(report4);
    await proxy.report.insert(report5);

    var proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report1), true);
    expect(proxyResult.result?.contains(report2), true);
    expect(proxyResult.result?.contains(report3), true);
    expect(proxyResult.result?.contains(report4), true);
    expect(proxyResult.result?.contains(report5), true);

    final report3new = Report(id: report3.id, note: "Semana-New-3", reportDate: 1256333, value: 110333, tableId: reportTable.id!);

    await proxy.report.delete(report4);
    await proxy.report.update(report3new);

    proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report1), true);
    expect(proxyResult.result?.contains(report2), true);
    expect(proxyResult.result?.contains(report3), false);
    expect(proxyResult.result?.contains(report3new), true);
    expect(proxyResult.result?.contains(report4), false);
    expect(proxyResult.result?.contains(report5), true);
  });
  
  test('Report insert all test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    await proxy.reportTable.insert(reportTable);

    final reports = <Report>[];
    for (var i = 0; i < 100; i++) {
      final report = Report(id: Uuid().v4(), note: "Semana-$i", reportDate: 1256 * i, value: 110.0 * i, tableId: reportTable.id!);
      reports.add(report);
    }

    await proxy.report.insertAll(reports);

    final proxyResult = await proxy.report.selectAll();
    for (var report in reports) {
      expect(proxyResult.result?.contains(report), true);
    }
  });
  
  test('Report exists test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    await proxy.reportTable.insert(reportTable);

    final report = Report(id: Uuid().v4(), note: "Semana-0", reportDate: 1256, value: 110, tableId: reportTable.id!);
    await proxy.report.insert(report);

    final proxyResult = await proxy.report.existsById(report.id!);
    expect(proxyResult.result, true);
  });

  test('Report upsert test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    await proxy.reportTable.insert(reportTable);

    final report = Report(id: Uuid().v4(), note: "Semana-0", reportDate: 1256, value: 110, tableId: reportTable.id!);

    await proxy.report.upsert(report);
    var proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report), true);

    final report2 = Report(id: report.id, note: "Semana-1", reportDate: 12562, value: 1102, tableId: reportTable.id!);
    await proxy.report.upsert(report2);

    proxyResult = await proxy.report.selectAll();
    expect(proxyResult.result?.contains(report), false);
    expect(proxyResult.result?.contains(report2), true);
  });
}

void exerciseTest() {
  test('Exercise insert test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
  
    await proxy.exercise.insert(exercise);
    final proxyResult = await proxy.exercise.selectAll();
    expect(proxyResult.result?.contains(exercise), true);
  });
  
  test('Exercise insert error same id', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
  
    var proxyResult = await proxy.exercise.insert(exercise);
    expect(proxyResult.result, true);
  
    proxyResult = await proxy.exercise.insert(exercise, printLog: false);
    expect(proxyResult.result, false);
  });
  
  test('Exercise delete test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
  
    await proxy.exercise.insert(exercise);
    var proxyResult = await proxy.exercise.selectAll();
  
    expect(proxyResult.result?.contains(exercise), true);
  
    await proxy.exercise.delete(exercise);
    proxyResult = await proxy.exercise.selectAll();
  
    expect(proxyResult.result?.contains(exercise), false);
  });

  test('Exercise delete all test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
  
    await proxy.exercise.insert(exercise);
    var proxyResult = await proxy.exercise.selectAll();
    expect(proxyResult.result?.contains(exercise), true);
  
    await proxy.exercise.deleteAll();
    proxyResult = await proxy.exercise.selectAll();
  
    expect(proxyResult.result?.isEmpty, true);
  });
  
  test('Exercise update test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
  
    await proxy.exercise.insert(exercise);
    var proxyResult = await proxy.exercise.selectAll();
    expect(proxyResult.result?.contains(exercise), true);
  
    Exercise exercise1 = Exercise(id: exercise.id, name: "test 2", amount: 20, reps: 25, sets: 411, type: ExerciseType.cardio);
  
    await proxy.exercise.update(exercise1);
    proxyResult = await proxy.exercise.selectAll();
    expect(proxyResult.result?.contains(exercise1), true);
    expect(proxyResult.result?.contains(exercise), false);
  });
  
  test('Exercise select all test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise1 = Exercise(id: Uuid().v4(), name: "test-1", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise2 = Exercise(id: Uuid().v4(), name: "test-2", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise3 = Exercise(id: Uuid().v4(), name: "test-3", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
  
    await proxy.exercise.insert(exercise1);
    await proxy.exercise.insert(exercise2);
    await proxy.exercise.insert(exercise3);
  
    Exercise exercise4 = Exercise(id: exercise1.id, name: exercise1.name, amount: 12, reps: 18, sets: 42, type: ExerciseType.cardio);
    await proxy.exercise.update(exercise4);
  
    final proxyResult = await proxy.exercise.selectAll();
    
    expect(proxyResult.result?.isNotEmpty, true);
    expect(proxyResult.result?.contains(exercise1), false);
    expect(proxyResult.result?.contains(exercise2), true);
    expect(proxyResult.result?.contains(exercise3), true);
    expect(proxyResult.result?.contains(exercise4), true);
  });
  
  test('Exercise insert all test', () async {
    final proxy = DatabaseProxy.instance;
    final exercises = <Exercise>[];
    for (var i = 0; i < 100; i++) {
      Exercise exercise = Exercise(id: Uuid().v4(), name: "test $i", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
      exercises.add(exercise);
    }
  
    await proxy.exercise.insertAll(exercises);
    final proxyResult = await proxy.exercise.selectAll();
  
    for (var exercise in exercises) {
      expect(proxyResult.result?.contains(exercise), true);
    }
  });
  
  test('Exercise exists test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
  
    await proxy.exercise.insert(exercise);
    var proxyResult = await proxy.exercise.existsById(exercise.id!);
    expect(proxyResult.result, true);
  
    await proxy.exercise.delete(exercise);
    proxyResult = await proxy.exercise.existsById(exercise.id!);
    expect(proxyResult.result, false);
  });

  test('Exercise upsert test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
  
    await proxy.exercise.upsert(exercise);
    var proxyResult = await proxy.exercise.selectAll();
    expect(proxyResult.result?.contains(exercise), true);

    final exercise2 = Exercise(id: exercise.id, name: "test-2", amount: 152, reps: 152, sets: 42, type: ExerciseType.cardio);
    await proxy.exercise.upsert(exercise2);
    proxyResult = await proxy.exercise.selectAll();
    expect(proxyResult.result?.contains(exercise), false);
    expect(proxyResult.result?.contains(exercise2), true);
  });
}

void metadataTest() {
  test('Metadata insert test', () async {
    final proxy = DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config", "test");
    await proxy.metadata.insert(entry);
    
    final proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), true);
  });
  
  test('Metadata insert same id', () async {
    final proxy = DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config-3", "test");
  
    await proxy.metadata.insert(entry);
    var proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), true);
  
    entry = MapEntry(entry.key, "test-2");
  
    await proxy.metadata.insert(entry, printLog: false);
    proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), false);
  });
  
  test('Metadata delete test', () async {
    final proxy = DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config-2", "test");
  
    await proxy.metadata.insert(entry);
    var proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), true);
  
    await proxy.metadata.delete(entry);
    proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), false);
  });

  test('Metadata delete all test', () async {
    final proxy = DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config-2", "test");
  
    await proxy.metadata.insert(entry);
    var proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), true);
  
    await proxy.metadata.deleteAll();
    proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.isEmpty, true);
  });
  
  test('Metadata update test', () async {
    final proxy = DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config-500", "test");
  
    await proxy.metadata.insert(entry);
    var proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), true);
  
    final entry1 = MapEntry(entry.key, "test-500");
    await proxy.metadata.update(entry1);
    proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), false);
    expect(proxyResult.result?.any((element) => element.key == entry1.key && element.value == entry1.value), true);
  });
  
  test('Metadata select all test', () async {
    final proxy = DatabaseProxy.instance;
    MapEntry<String, String> entry1 = MapEntry("config-41", "test-1");
    MapEntry<String, String> entry2 = MapEntry("config-42", "test-2");
    MapEntry<String, String> entry3 = MapEntry("config-43", "test-3");
    MapEntry<String, String> entry4 = MapEntry("config-44", "test-4");
    MapEntry<String, String> entry5 = MapEntry("config-45", "test-5");
  
    await proxy.metadata.insert(entry1);
    await proxy.metadata.insert(entry2);
    await proxy.metadata.insert(entry3);
    await proxy.metadata.insert(entry4);
    await proxy.metadata.insert(entry5);
  
    entry5 = MapEntry("config-45", "test-90");
    await proxy.metadata.update(entry5);
  
    await proxy.metadata.delete(entry4);
  
    var proxyResult = await proxy.metadata.selectAll();    
  
    expect(proxyResult.result?.any((element) => element.key == entry1.key && element.value == entry1.value), true);  
    expect(proxyResult.result?.any((element) => element.key == entry2.key && element.value == entry2.value), true);
    expect(proxyResult.result?.any((element) => element.key == entry3.key && element.value == entry3.value), true);   
    expect(proxyResult.result?.any((element) => element.key == entry4.key && element.value == entry4.value), false);   
    expect(proxyResult.result?.any((element) => element.key == entry5.key && element.value == entry5.value), true);
  });
  
  test('Metadata insert all test', () async {
    final proxy = DatabaseProxy.instance;
    Map<String, String> map = {};
    for (var i = 0; i < 100; i++) {
      map["Configs-$i"] = "test $i";
    }
  
    await proxy.metadata.insertAll(map.entries.toList());
    var proxyResult = await proxy.metadata.selectAll();  
  
    for (var entry in map.entries) {
      expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), true);  
    }  
  });
  
  test('Metadata exists test', () async {
    final proxy = DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config-99", "test");
  
    await proxy.metadata.insert(entry);
    var proxyResult = await proxy.metadata.existsById(entry.key);    
    expect(proxyResult.result, true);
  
    await proxy.metadata.delete(entry);
    proxyResult = await proxy.metadata.existsById(entry.key);    
    expect(proxyResult.result, false);
  });

  test('Metadata upsert test', () async {
    final proxy = DatabaseProxy.instance;
    MapEntry<String, String> entry = MapEntry("config", "test");

    await proxy.metadata.upsert(entry);
    var proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), true);

    MapEntry<String, String> entry2 = MapEntry(entry.key, "test-2");
    await proxy.metadata.upsert(entry2);
    proxyResult = await proxy.metadata.selectAll();    
    expect(proxyResult.result?.any((element) => element.key == entry.key && element.value == entry.value), false);
    expect(proxyResult.result?.any((element) => element.key == entry2.key && element.value == entry2.value), true);
  });
}

void reportTableTest() {
  test('ReportTable insert test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    
    await proxy.reportTable.insert(reportTable);
    final proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable), true);
  }); 
  
  test('ReportTable insert same id', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    
    await proxy.reportTable.insert(reportTable);
    var proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable), true);
  
    final reportTable2 = ReportTable(id: reportTable.id, name: "Pesagem-2", description: "BLABLABLA2", valueSuffix: "Kg2", createdAt: 13256718, updatedAt: 5757818944);
    
    await proxy.reportTable.insert(reportTable2, printLog: false);
    proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable2), false);
  });
  
  test('ReportTable delete test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    
    await proxy.reportTable.insert(reportTable);
    var proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable), true);
  
    await proxy.reportTable.delete(reportTable);
    proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable), false);
  });

  test('ReportTable delete all test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    
    await proxy.reportTable.insert(reportTable);
    var proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable), true);
  
    await proxy.reportTable.deleteAll();
    proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.isEmpty, true);
  });
  
  test('ReportTable update test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    
    await proxy.reportTable.insert(reportTable);
    var proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable), true);
  
    final reportTable1 = ReportTable(id: reportTable.id, name: "Pesagem2", description: "BLABLABLA2", valueSuffix: "Kg2", createdAt: 132523678, updatedAt: 57572488944);
  
    await proxy.reportTable.update(reportTable1);
    proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable), false);
    expect(proxyResult.result?.contains(reportTable1), true);
  });
  
  test('ReportTable select all test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable1 = ReportTable(id: Uuid().v4(), name: "Pesagem1", description: "BLABLABLA1", valueSuffix: "Kg", createdAt: 13256781, updatedAt: 5757188944);
    final reportTable2 = ReportTable(id: Uuid().v4(), name: "Pesagem2", description: "BLABLABLA2", valueSuffix: "Kg", createdAt: 132567811, updatedAt: 5757288944);
    final reportTable3 = ReportTable(id: Uuid().v4(), name: "Pesagem3", description: "BLABLABLA3", valueSuffix: "Kg", createdAt: 1325678111, updatedAt: 57571388944);
    final reportTable4 = ReportTable(id: Uuid().v4(), name: "Pesagem4", description: "BLABLABLA4", valueSuffix: "Kg", createdAt: 13256781111, updatedAt: 5757488944);
    
    await proxy.reportTable.insert(reportTable1);
    await proxy.reportTable.insert(reportTable2);
    await proxy.reportTable.insert(reportTable3);
    await proxy.reportTable.insert(reportTable4);
  
    final proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable1), true);
    expect(proxyResult.result?.contains(reportTable2), true);
    expect(proxyResult.result?.contains(reportTable3), true);
    expect(proxyResult.result?.contains(reportTable4), true);
  });
  
  test('ReportTable insert all test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTableList = <ReportTable>[];
    for (var i = 0; i < 100; i++) {
      final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem-$i", description: "BLABLABLA-$i", valueSuffix: "Kg-$i", createdAt: 1325678, updatedAt: 575788944);
      reportTableList.add(reportTable);
    }
  
    await proxy.reportTable.insertAll(reportTableList);
    final proxyResult = await proxy.reportTable.selectAll();
  
    for (var table in reportTableList) {
      expect(proxyResult.result?.contains(table), true);
    }
  });
  
  test('ReportTable exists test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    
    await proxy.reportTable.insert(reportTable);
    var exist = await proxy.reportTable.existsById(reportTable.id!);
    expect(exist.result, true);
  
    await proxy.reportTable.delete(reportTable);
    exist = await proxy.reportTable.existsById(reportTable.id!);
    expect(exist.result, false);
  });

  test('ReportTable upsert test', () async {
    final proxy = DatabaseProxy.instance;
    final reportTable = ReportTable(id: Uuid().v4(), name: "Pesagem", description: "BLABLABLA", valueSuffix: "Kg", createdAt: 1325678, updatedAt: 575788944);
    
    await proxy.reportTable.upsert(reportTable);
    var proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable), true);

    final reportTable2 = ReportTable(id: reportTable.id, name: "Pesagem-2", description: "BLABLABLA-2", valueSuffix: "Kg-2", createdAt: 13256782, updatedAt: 5757889442);
    await proxy.reportTable.upsert(reportTable2);
    proxyResult = await proxy.reportTable.selectAll();
    expect(proxyResult.result?.contains(reportTable), false);
    expect(proxyResult.result?.contains(reportTable2), true);
  }); 
}

void trainingPlanTest() {
  test('TrainingPlan insert test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    await proxy.trainingPlan.insert(plan);
    final proxyResult = await proxy.trainingPlan.selectAll();
  
    expect(proxyResult.result?.contains(plan), true);
  });
  
  test('TrainingPlan insert error same id', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    
    var proxyResult = await proxy.trainingPlan.insert(plan);
    expect(proxyResult.result, true);
  
    proxyResult = await proxy.trainingPlan.insert(plan, printLog: false);
    expect(proxyResult.result, false);
  });
  
  test('TrainingPlan delete test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    
    await proxy.trainingPlan.insert(plan);
    var proxyResult = await proxy.trainingPlan.selectAll();
    expect(proxyResult.result?.contains(plan), true);
  
    await proxy.trainingPlan.delete(plan);
    proxyResult = await proxy.trainingPlan.selectAll();
    expect(proxyResult.result?.contains(plan), false);
  });

  test('TrainingPlan delete all test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    
    await proxy.trainingPlan.insert(plan);
    var proxyResult = await proxy.trainingPlan.selectAll();
    expect(proxyResult.result?.contains(plan), true);
  
    await proxy.trainingPlan.deleteAll();
    proxyResult = await proxy.trainingPlan.selectAll();
    expect(proxyResult.result?.isEmpty, true);
  });
  
  test('TrainingPlan update test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    
    await proxy.trainingPlan.insert(plan);
    var proxyResult = await proxy.trainingPlan.selectAll();
    expect(proxyResult.result?.contains(plan), true);
  
    TrainingPlan plan1 = TrainingPlan(id: plan.id, name: "Treino B", list: plan.list);
  
    await proxy.trainingPlan.update(plan1);
    proxyResult = await proxy.trainingPlan.selectAll();
    expect(proxyResult.result?.contains(plan1), true);
    expect(proxyResult.result?.contains(plan), false);
  });
  
  test('TrainingPlan select all test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise1 = Exercise(id: Uuid().v4(), name: "test-1", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise2 = Exercise(id: Uuid().v4(), name: "test-2", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise3 = Exercise(id: Uuid().v4(), name: "test-3", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    Exercise exercise5 = Exercise(id: Uuid().v4(), name: "test-3", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
  
    await proxy.exercise.insert(exercise1);
    await proxy.exercise.insert(exercise2);
    await proxy.exercise.insert(exercise3);
    await proxy.exercise.insert(exercise5);
  
    TrainingPlan trainingPlan1 = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise1.id!]);
    TrainingPlan trainingPlan2 = TrainingPlan(id: Uuid().v4(), name: "Treino B", list: [exercise1.id!, exercise2.id!]);
    TrainingPlan trainingPlan3 = TrainingPlan(id: Uuid().v4(), name: "Treino C", list: [exercise1.id!, exercise3.id!]);
    TrainingPlan trainingPlan5 = TrainingPlan(id: Uuid().v4(), name: "Treino F", list: [exercise1.id!, exercise3.id!]);
  
    await proxy.trainingPlan.insert(trainingPlan1);
    await proxy.trainingPlan.insert(trainingPlan2);
    await proxy.trainingPlan.insert(trainingPlan3);
    await proxy.trainingPlan.insert(trainingPlan5);
  
    TrainingPlan trainingPlan4 = TrainingPlan(id: trainingPlan3.id, name: "Treino D", list: trainingPlan3.list);
    await proxy.trainingPlan.update(trainingPlan4);
    await proxy.trainingPlan.delete(trainingPlan5);
  
    final proxyResult = await proxy.trainingPlan.selectAll();
  
    expect(proxyResult.result?.isNotEmpty, true);
    expect(proxyResult.result?.contains(trainingPlan3), false);
    expect(proxyResult.result?.contains(trainingPlan5), false);
    expect(proxyResult.result?.contains(trainingPlan1), true);
    expect(proxyResult.result?.contains(trainingPlan2), true);
    expect(proxyResult.result?.contains(trainingPlan4), true);
  });
  
  test('TrainingPlan insert all test', () async {
    final proxy = DatabaseProxy.instance;
  
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test-1", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
  
    final plans = <TrainingPlan>[];
    for (var i = 0; i < 100; i++) {
      TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A $i", list: [exercise.id!]);
      plans.add(plan);
    }
    
    await proxy.trainingPlan.insertAll(plans);
  
    final proxyResult = await proxy.trainingPlan.selectAll();
  
    for (var plan in plans) {
      expect(proxyResult.result?.contains(plan), true);
    }
  });
  
  test('TrainingPlan exists test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
  
    await proxy.trainingPlan.insert(plan);
    var proxyResult = await proxy.trainingPlan.existsById(plan.id!);
    expect(proxyResult.result, true);
  
    await proxy.trainingPlan.delete(plan);
    proxyResult = await proxy.trainingPlan.existsById(plan.id!);
    expect(proxyResult.result, false);
  });

  test('TrainingPlan upsert test', () async {
    final proxy = DatabaseProxy.instance;
    Exercise exercise = Exercise(id: Uuid().v4(), name: "test", amount: 15, reps: 15, sets: 4, type: ExerciseType.musclework);
    await proxy.exercise.insert(exercise);
    
    TrainingPlan plan = TrainingPlan(id: Uuid().v4(), name: "Treino A", list: [exercise.id!]);
    await proxy.trainingPlan.upsert(plan);
    var proxyResult = await proxy.trainingPlan.selectAll();
    expect(proxyResult.result?.contains(plan), true);

    TrainingPlan plan2 = TrainingPlan(id: plan.id, name: "Treino AA", list: [exercise.id!, exercise.id!]);
    await proxy.trainingPlan.upsert(plan2);
    proxyResult = await proxy.trainingPlan.selectAll();
    expect(proxyResult.result?.contains(plan), false);
    expect(proxyResult.result?.contains(plan2), true);
  });
}