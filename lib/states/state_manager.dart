import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/auth_state.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/utils/cloud/async_debouncer.dart';
import 'package:fittrackr/utils/cloud/firebase_options.dart';
import 'package:fittrackr/utils/cloud/firestore.dart';
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
      state.addListener(_sync);
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

  final AsyncDebouncer _debouncer = AsyncDebouncer(delay: Duration(seconds: 3));
  
  SaveResult? lastSaveResult;
  int retryCount = 0;

  bool _synchronized = false;
  Duration _retryDelay = Duration(seconds: 1);
  final Duration _maxRetryDelay = Duration(minutes: 1);
  final int maxRetry = 20;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  // sync options

  void _sync() {
    if(authState.isLoggedIn && _synchronized) {
      _debouncer.call(() async {
        if(_isSyncing || !_synchronized) return;
        _isSyncing = true;

        try {
          return await FirestoreUtils
            .saveData(this, metadataState.get(lastUpdateKey))
            .then(_handleSaveResult);
        } finally {
          _isSyncing = false;
        }
      });
    }
  }

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
        _handleSaveResult(SaveResult(SaveStatus.desynchronized, null, null));
      }
      startPeriodicSync(Duration(minutes: 15));
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> forceSyncLocalToCloud() async {
    if(_isSyncing) return;
    _isSyncing = true;

    try {
      if(authState.user == null) return;
      await FirestoreUtils.saveData(this, "bypassed", true)
          .then(_handleSaveResult);
      startPeriodicSync(Duration(minutes: 15));
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> forceSyncCloudToLocal() async {
    if(_isSyncing) return;
    _isSyncing = true;

    try {
      final result = await FirestoreUtils.loadData(this);
      if(result.status == LoadStatus.success) {
        _handleSaveResult(SaveResult(SaveStatus.success, result.timestamp, result.lastDataHash));
      }
      _sync();
    } finally {
      _isSyncing = false;
    }
  }

  // utils

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
        Future.delayed(_retryDelay, _sync);
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

  DateTime? getLocalTimeStamp() {
    final localTimeStamp = metadataState.get(lastTimeStampKey);
    if(localTimeStamp != null) {
      return DateTime.parse(localTimeStamp);
    }
    return null;
  }
}
