import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/utils/firebase_options.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/auth_state.dart';
import 'package:fittrackr/states/base_list_state.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/utils/firestore.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:flutter/material.dart';

// StateManager

class StateManager extends ChangeNotifier {
  late final ExercisesState exercisesState;
  late final MetadataState metadataState;
  late final TrainingPlanState trainingPlanState;
  late final TrainingHistoryState trainingHistoryState;
  late final ReportTableState reportTableState;
  late final ReportState reportState;
  late final AuthState authState;

  Future<void> initialize() async {
    final db = DatabaseProxy.instance;
    exercisesState = ExercisesState(dbProxy: db.exercise, loadDatabase: true);
    metadataState = MetadataState(dbProxy: db.metadata, loadDatabase: true);
    trainingPlanState = TrainingPlanState(dbProxy: db.trainingPlan, loadDatabase: true);
    trainingHistoryState = TrainingHistoryState(dbProxy: db.trainingHistory, loadDatabase: true);
    reportTableState = ReportTableState(dbProxy: db.reportTable, loadDatabase: true);
    reportState = ReportState(dbProxy: db.report, loadDatabase: true);

    final firebaseInitialization = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    await Future.wait([
      exercisesState.waitLoaded(),
      metadataState.waitLoaded(),
      trainingPlanState.waitLoaded(),
      trainingHistoryState.waitLoaded(),
      reportTableState.waitLoaded(),
      reportState.waitLoaded(),
      firebaseInitialization,
    ]);

    final watchedStates = [
      exercisesState,
      trainingPlanState,
      trainingHistoryState,
      reportTableState,
      reportState
    ];
    for (var state in watchedStates) {
      state.addListener(handleUpdate);
    }

    authState = AuthState();
    authState.addListener(() {
      if(authState.isLoggedIn) {
        trySync();
      } else {
        stopPeriodicSync();
      }
    },);
  }

  final AsyncDebouncer _debouncer = AsyncDebouncer(delay: Duration(seconds: 1));
  
  SaveResult? lastSaveResult;
  int retryCount = 0;

  bool _synchronized = false;
  Duration _retryDelay = Duration(seconds: 1);
  final Duration _maxRetryDelay = Duration(minutes: 1);
  final int maxRetry = 20;

  bool _isSyncing = false;

  Future<void> trySync() async {
    if(_isSyncing) return;
    _isSyncing = true;

    try {
      if(authState.user == null) return;
      final lastHash = metadataState.get(lastUpdateKey);
      final syncronized = await FirestoreUtils.checkSynchronized(authState.user!.uid, lastHash);
      if(syncronized) {
        await FirestoreUtils.saveData(this, lastHash)
          .then(_handleSaveResult);
      } else {
        lastSaveResult = SaveResult(SaveStatus.desynchronized, null, null);
      }
      startPeriodicSync(Duration(minutes: 15));
    } finally {
      _isSyncing = false;
    }
  }

  void handleUpdate() {
    if(authState.isLoggedIn && _synchronized) {
      _debouncer.call(() async {
        if(_isSyncing) return;
        _isSyncing = true;

        try {
          return FirestoreUtils
            .saveData(this, metadataState.get(lastUpdateKey))
            .then(_handleSaveResult);
        } finally {
          _isSyncing = false;
        }
      });
    }
  }
  
  void _handleSaveResult(SaveResult result) {
    lastSaveResult = result;
    if(result.status == SaveStatus.desynchronized) {
      _synchronized = false;
      _retryDelay = Duration(seconds: 2);
      retryCount = 0;
    } else if(result.status == SaveStatus.success) {
      if(result.lastDataHash != null) {
        metadataState.put(lastUpdateKey, result.lastDataHash!);
      }
      if(result.timestamp != null) {
        metadataState.put(lastTimeStampKey, result.timestamp!.toDate().toIso8601String());
      }
      _synchronized = true;
      _retryDelay = Duration(seconds: 2);
      retryCount = 0;
    } else if(result.status == SaveStatus.error) {
      if (retryCount < maxRetry) {
        Future.delayed(_retryDelay, handleUpdate);
        retryCount++;
        _retryDelay = _retryDelay * 2 <= _maxRetryDelay ? _retryDelay * 2 : _maxRetryDelay;
      } else {
        logger.e("Max retries reached, giving up.");
      }
    }
    notifyListeners();
  }

  Timer? _periodicTimer;
  void startPeriodicSync(Duration interval) {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(interval, (_) => trySync());
  }
  void stopPeriodicSync() => _periodicTimer?.cancel();
}

class AsyncDebouncer {
  final Duration delay;
  Timer? _timer;
  Completer<void>? _running;
  bool _pending = false;

  AsyncDebouncer({required this.delay});

  Future<void> call(Future<void> Function() action) async {
    _timer?.cancel();
    _timer = Timer(delay, () async {
      if (_running != null) {
        _pending = true;
        return;
      }

      _running = Completer<void>();
      await action();
      _running!.complete();
      _running = null;

      if (_pending) {
        _pending = false;
        await call(action);
      }
    });
  }
}

// Serializer

class SerializationResult {
  final Uint8List compressed;
  final String json;

  SerializationResult(this.compressed, this.json);
}

class Serializer {
  static SerializationResult serialize(List<BaseListState> states) {    
    Map<String, Object> map = {};
    for (var state in states) {
      if(state.isNotEmpty) {
        map[state.serializationKey] = state.clone.map((e) => e.toMap()).toList();
      }
    }
    final json = jsonEncode(map);
    final compressed = _zipData(json);
    return SerializationResult(compressed, json);
  }

  static Uint8List _zipData(String data) {
    final runes = data.runes;
    Archive archive = Archive()
      ..addFile(ArchiveFile("data.bin", runes.length, runes.toList()));
    return ZipEncoder().encodeBytes(
      archive,
      level:
          data.length > 500000
              ? DeflateLevel.bestCompression
              : DeflateLevel.bestSpeed,
    );
  }
}