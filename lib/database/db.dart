import 'package:fittrackr/database/_database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:convert';

import 'package:fittrackr/database/entities.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';

import 'dart:async';
import 'dart:isolate';
import 'package:uuid/uuid.dart';


abstract class _Keys {
  static const id = "id";
  static const task = "task";
  static const table = "table";
  static const payload = "payload";

  static const success = "success";
  static const data = "data";
  static const error = "error";
  static const stack = "stack";

  static const insert = "insert";
  static const delete = "delete";
  static const update = "update";
  static const selectAll = "selectAll";

  static const exercise = "exercise";
  static const trainingPlan = "training_plan";
}


// Proxy

enum ProxyStatus {notInitiated, operational}

class DatabaseProxy {
  ProxyStatus _status = ProxyStatus.notInitiated;
  late final ReceivePort _mainReceivePort;
  late final SendPort _workerSendPort;

  final Map<String, Completer<Map<String, Object>>> completerMap = {};

  DatabaseProxy._internal();
  static final DatabaseProxy _instance = DatabaseProxy._internal();
  factory DatabaseProxy() => _instance;

  ProxyStatus get status => _status;
  
  static Future<DatabaseProxy> get instance async {
    if(_instance._status == ProxyStatus.operational) {
      return _instance;
    }
    await _instance._initWorker();
    return _instance;
  }

  Future<void> _initWorker() async {
    _mainReceivePort = ReceivePort();
    await Isolate.spawn(_Worker.run, _mainReceivePort.sendPort);
    final broadcastStream = _mainReceivePort.asBroadcastStream();

    _workerSendPort = await broadcastStream.first as SendPort;
    broadcastStream.listen(_onData);

    _status = ProxyStatus.operational;
  }

  void _onData(dynamic data) {
    if(data is Map<String, Object>) {
      Object? completerID = data[_Keys.id];
      if(completerMap.containsKey(completerID)) {
        data.remove(_Keys.id);
        completerMap[completerID]!.complete(data);
        completerMap.remove(completerID);
      }
    }
  }

  Future<Map<String, Object>> _execute(String task, String table, String payload) {
    final taskID = Uuid().v4();
    final completer = Completer<Map<String, Object>>();
    completerMap[taskID] = completer;

    _workerSendPort.send({_Keys.id: taskID, _Keys.task: task, _Keys.table: table, _Keys.payload: payload});

    return completer.future;
  }

  late final ProxyPart<Exercise> exercise = ExerciseProxy(this);
  late final ProxyPart<TrainingPlan> trainingPlan = TrainingPlanProxy(this);  
}


class ExerciseProxy implements ProxyPart<Exercise> {
  final DatabaseProxy _dbProxy;

  ExerciseProxy(this._dbProxy);

  @override
  Future<Map<String, Object>> insert(Exercise exercise) {
    return _dbProxy._execute(_Keys.insert, _Keys.exercise, jsonEncode(exercise.toMap()));
  }

  @override
  Future<Map<String, Object>> delete(Exercise exercise) {
    return _dbProxy._execute(_Keys.delete, _Keys.exercise, jsonEncode(exercise.toMap()));
  }

  @override
  Future<Map<String, Object>> update(Exercise exercise) {
    return _dbProxy._execute(_Keys.update, _Keys.exercise, jsonEncode(exercise.toMap()));
  }

  @override
  Future<Map<String, Object>> selectAll() async {
    final result = await _dbProxy._execute(_Keys.selectAll, _Keys.exercise, "");
    if(result.containsKey(_Keys.data)) {
      result[_Keys.data] = (result["data"] as List<Map<String, Object?>>)
              .map(Exercise.fromMap)
              .toList();
    } 
    return result;
  }
}

class TrainingPlanProxy implements ProxyPart<TrainingPlan> {
  final DatabaseProxy _dbProxy;

  TrainingPlanProxy(this._dbProxy);

  @override
  Future<Map<String, Object>> insert(TrainingPlan plan) {
    return _dbProxy._execute(_Keys.insert, _Keys.trainingPlan, jsonEncode(plan.toMap()));
  }

  @override
  Future<Map<String, Object>> delete(TrainingPlan plan) {
    return _dbProxy._execute(_Keys.delete, _Keys.trainingPlan, jsonEncode(plan.toMap()));
  }

  @override
  Future<Map<String, Object>> update(TrainingPlan plan) {
    return _dbProxy._execute(_Keys.update, _Keys.trainingPlan, jsonEncode(plan.toMap()));
  }

  @override
  Future<Map<String, Object>> selectAll() async {
    final result = await _dbProxy._execute(_Keys.selectAll, _Keys.trainingPlan, "");
    if(result.containsKey(_Keys.data)) {
      result[_Keys.data] = (result["data"] as List<Map<String, Object?>>)
              .map(TrainingPlan.fromMap)
              .toList();
    } 
    return result;
  }
}

abstract class ProxyPart<T> {
  Future<Map<String, Object>> insert(T exercise);
  Future<Map<String, Object>> delete(T exercise);
  Future<Map<String, Object>> update(T exercise);
  Future<Map<String, Object>> selectAll();
}


// Worker

abstract class _Worker {

  static void run(SendPort mainSendPort) {
    final workerPort = ReceivePort();
    final lock = Lock();

    mainSendPort.send(workerPort.sendPort);

    workerPort.listen((task) {
      if (task is Map<String, Object>) {
        lock.synchronized(() async {
          try {
            final result = await _doWork(task);
            mainSendPort.send(result);
          } catch (e, stack) {
            mainSendPort.send({
              _Keys.id: task[_Keys.id]!, 
              _Keys.error: e.toString(), 
              _Keys.stack: stack.toString()
            });
          }
        });
      }
    });
  }

  static Future<Map<String, Object>> _doWork(Map<String, Object> task) async {
    switch (task[_Keys.task]) {
      case _Keys.insert:
        return await _insert(task);
      case _Keys.delete:
        return await _delete(task);
      case _Keys.update:
        return await _update(task);
      case _Keys.selectAll:
        return await _selectAll(task);
      default:
        return {
          _Keys.id: task[_Keys.id]!,
          _Keys.error: "key error task[_Keys.task] = ${task[_Keys.task]}",
        };
    }
  }

// jobs

  static Future<Map<String, Object>> _insert(Map<String, Object> task) async {
    final db = DatabaseHelper();
    final payload = task[_Keys.payload] as String;
    
    switch (task[_Keys.table]) {
      case _Keys.exercise:
        final exercise = Exercise.fromMap(jsonDecode(payload))!;
        await db.exercise.insert(exercise);
        break;
      case _Keys.trainingPlan:
        final plan = TrainingPlan.fromMap(jsonDecode(payload))!;
        await db.trainingPlan.insert(plan);
        break;
      default:
        return {
          _Keys.id: task[_Keys.id]!,
          _Keys.error: "key error task[_Keys.table] = ${task[_Keys.table]}",
        };
    }

    return {_Keys.id: task[_Keys.id]!, _Keys.success: true};
  }

  static Future<Map<String, Object>> _delete(Map<String, Object> task) async {
    final db = DatabaseHelper();
    final payload = task[_Keys.payload] as String;

    switch (task[_Keys.table]) {
      case _Keys.exercise:
        final exercise = Exercise.fromMap(jsonDecode(payload))!;
        await db.exercise.delete(exercise);
        break;
      case _Keys.trainingPlan:
        final plan = TrainingPlan.fromMap(jsonDecode(payload))!;
        await db.trainingPlan.delete(plan);
        break;
      default:
        return {
          _Keys.id: task[_Keys.id]!,
          _Keys.error: "key error task[_Keys.table] = ${task[_Keys.table]}",
        };
    }

    return {_Keys.id: task[_Keys.id]!, _Keys.success: true};
  }

  static Future<Map<String, Object>> _update(Map<String, Object> task) async {
    final db = DatabaseHelper();
    final payload = task[_Keys.payload] as String;

    switch (task[_Keys.table]) {
      case _Keys.exercise:
        final exercise = Exercise.fromMap(jsonDecode(payload))!;
        await db.exercise.update(exercise);
        break;
      case _Keys.trainingPlan:
        final plan = TrainingPlan.fromMap(jsonDecode(payload))!;
        await db.trainingPlan.update(plan);
        break;
      default:
        return {
          _Keys.id: task[_Keys.id]!,
          _Keys.error: "key error task[_Keys.table] = ${task[_Keys.table]}",
        };
    }

    return {_Keys.id: task[_Keys.id]!, _Keys.success: true};
  }

  static Future<Map<String, Object>> _selectAll(Map<String, Object> task) async {
    final db = DatabaseHelper();

    switch (task[_Keys.table]) {
      case _Keys.exercise:
        final data = await db.exercise.selectAll();
        final encodedData = data.map((e) => e.toMap()).toList();
        return {_Keys.id: task[_Keys.id]!, _Keys.success: true, _Keys.data: encodedData};
      case _Keys.trainingPlan:
        final data = await db.trainingPlan.selectAll();
        final encodedData = data.map((e) => e.toMap()).toList();
        return {_Keys.id: task[_Keys.id]!, _Keys.success: true, _Keys.data: encodedData};
      default:
        return {
          _Keys.id: task[_Keys.id]!,
          _Keys.error: "key error task[_Keys.table] = ${task[_Keys.table]}",
        };
    }
  }
}
