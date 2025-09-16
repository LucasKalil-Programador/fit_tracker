import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:fittrackr/database/db.dart';
import 'package:fittrackr/database/helper/helper.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/auth_state.dart';
import 'package:fittrackr/states/metadata_state.dart';
import 'package:fittrackr/states/periodic_sync_manager.dart';
import 'package:fittrackr/states/state_manager_extension.dart';
import 'package:fittrackr/utils/cloud/async_debouncer.dart';
import 'package:fittrackr/utils/cloud/firebase_options.dart';
import 'package:fittrackr/utils/cloud/firestore.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// StateManager

const lastUpdateKeyy = "Manager:LastUpdate";
const lastTimeStampKeyy = "Manager:LastTimeStamp";
const encryptionKey = "Manager:encryption";

class StateManager extends ChangeNotifier {
  late final ExercisesState exercisesState;
  late final TrainingPlanState trainingPlanState;
  late final TrainingHistoryState trainingHistoryState;
  late final ReportTableState reportTableState;
  late final ReportState reportState;

  late final MetadataState metadataState;
  late final FlutterSecureStorage safeStorage;
  late final AuthState authState;

  Future<void> initialize() async {
    final startTime = DateTime.now();

    safeStorage = FlutterSecureStorage();
    await loadDatabasePassword();
    await loadStates();
    
    final elapsed = DateTime.now().difference(startTime);
    logger.i("Elapsed in loading: $elapsed");
  }

  Future<void> loadDatabasePassword() async {
    final password = await safeStorage.read(key: encryptionKey);
    if(password != null) {
      DatabaseHelper.password = password;
    } else {
      final secureRandom = Random.secure();
      final newPasswordBytes = Uint8List.fromList(
        List<int>.generate(32, (_) => secureRandom.nextInt(256)),
      );
    
      String newPassword = String.fromCharCodes(newPasswordBytes);
      DatabaseHelper.password = newPassword;
      await safeStorage.write(key: encryptionKey, value: newPassword);
    }
  }

  Future<void> loadStates() async {
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
      exercisesState.waitLoad().then((_) => exercisesState.addListener(_sync)),
      trainingPlanState.waitLoad().then((_) => trainingPlanState.addListener(_sync)),
      trainingHistoryState.waitLoad().then((_) => trainingHistoryState.addListener(_sync)),
      reportTableState.waitLoad().then((_) => reportTableState.addListener(_sync)),
      reportState.waitLoad().then((_) => reportState.addListener(_sync)),
      metadataState.waitLoad().then((_) => metadataState.addListener(_sync)),
      firebaseInitialization,
    ]);
    
    authState = AuthState();
    _periodicSync = PeriodicSyncManager(trySync);
    authState.addListener(() => authState.isLoggedIn ? trySync() : _periodicSync.stop());
  }

  final AsyncDebouncer _debouncer = AsyncDebouncer(delay: Duration(seconds: 3));
  late final PeriodicSyncManager _periodicSync;
  
  SaveResult? lastSaveResult;

  // retry variables
  Duration _retryDelay = Duration(seconds: 1);
  int retryCount = 0;

  // retry consts
  static const Duration _maxRetryDelay = Duration(minutes: 1);
  static final int _maxRetry = 20;

  // syncronization controler
  bool _synchronized = false;
  bool _isSyncing = false;

  // sync options

  void _sync() {
    if(authState.isLoggedIn && _synchronized) {
      _debouncer.call(() async {
        if(_isSyncing || !_synchronized) return;
        _isSyncing = true;

        try {
          return await FirestoreUtils
            .saveData(this, await getLastHash())
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
      final lastHash = await getLastHash();
      final syncronized = await FirestoreUtils.checkSynchronized(authState.user!.uid, lastHash);
      if(syncronized) {
        await FirestoreUtils.saveData(this, lastHash)
          .then(_handleSaveResult);
      } else {
        await _handleSaveResult(SaveResult(SaveStatus.desynchronized, null, null));
      }
      _periodicSync.start(Duration(minutes: 10));
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
      _periodicSync.start(Duration(minutes: 15));
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
        await _handleSaveResult(SaveResult(SaveStatus.success, result.timestamp, result.lastDataHash));
      }
      _sync();
    } finally {
      _isSyncing = false;
    }
  }

  // utils

  Future<bool> deleteAccount() async {
    while(_isSyncing) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    _isSyncing = true;

    try {
      if (authState.isLoggedIn) {
        await FirestoreUtils.deleteAccount(authState.user!.uid);
        return await authState.signOut();
      }
      return false;
    } catch (e) {
      logger.w('Error deleting account: $e');
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _handleSaveResult(SaveResult result) async {
    lastSaveResult = result;
    if(result.status == SaveStatus.desynchronized) {
      _onDesynchronized();
    } else if(result.status == SaveStatus.success) {
      await _onSuccess(result);
    } else if(result.status == SaveStatus.error) {
      _onError();
    }
    notifyListeners();
  }

  void _onDesynchronized() {
    _synchronized = false;
    _retryDelay = Duration(seconds: 2);
    retryCount = 0;
  }

  Future<void> _onSuccess(SaveResult result) async {
    if(result.lastDataHash != null && result.timestamp != null) {
      await setLastHash(result.lastDataHash!);
      await setLocalTimeStamp(result.timestamp!.toDate());
      _synchronized = true;
      _retryDelay = Duration(seconds: 2);
      retryCount = 0;
    }
  }

  void _onError() {
    if (retryCount < _maxRetry) {
      Future.delayed(_retryDelay, _sync);
      retryCount++;
      _retryDelay = _retryDelay * 2 <= _maxRetryDelay ? _retryDelay * 2 : _maxRetryDelay;
    } else {
      logger.e("Max retries reached, giving up.");
    }
  }
}
