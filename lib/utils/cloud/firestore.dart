
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:fittrackr/states/state_manager.dart';
import 'package:fittrackr/utils/cloud/serializer.dart';
import 'package:fittrackr/utils/logger.dart';

enum SaveStatus { error, success, disconnected, desynchronized }

class SaveResult {
  SaveStatus status;
  Timestamp? timestamp;
  String? lastDataHash;

  SaveResult(this.status, this.timestamp, this.lastDataHash);
}

enum LoadStatus { error, success, disconnected, deserializationError }

class LoadResult {
  LoadStatus status;
  Timestamp? timestamp;
  String? lastDataHash;
  DeserializationResult? result;

  LoadResult(this.status, this.timestamp, this.lastDataHash, this.result);
}

class FirestoreUtils {
  static Future<SaveResult> saveData(StateManager manager, String? lastHash, [bool bypassHash = false]) async {
    try {
      final user = manager.authState.user;
      if (user == null) {
        return SaveResult(SaveStatus.disconnected, null, null);
      }

      final serializationResult = _getData(manager);
      final json = serializationResult.json;
      final data = serializationResult.compressed;
      final newHash = _computeHash(json);

      final result = await _saveBlob(
        data,
        lastHash,
        newHash,
        user.uid,
        user.displayName,
        bypassHash
      );

      logger.i(
        "SaveData: json length=${json.length}, compressed=${data.length}, status=${result.status}"
      );
      return result;
    } catch (e, st) {
      logger.e("Error in saveData", error: e, stackTrace: st);
      return SaveResult(SaveStatus.error, null, null);
    }
  }

  static Future<bool> checkSynchronized(String uid, String? lastHash) async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection("user_data").doc(uid).get();
    final existing = snapshot.data();

    if (existing != null) {
      final currentHash = existing["data_hash"];
      if (currentHash is String && currentHash != lastHash) {
        logger.w("Conflict detected. Local hash=$lastHash, remote hash=$currentHash");
        return false;
      }
    }
    return true;
  }

  static Future<DateTime?> getServerTimeStamp(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection("user_data").doc(uid);

    try {
      final snapshot = await docRef.get();
      final serverTimestamp = snapshot["timestamp"];
      if(serverTimestamp is Timestamp) {
        return serverTimestamp.toDate();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<LoadResult> loadData(StateManager manager) async {
    try {
      final user = manager.authState.user;
      if (user == null) {
        return LoadResult(LoadStatus.disconnected, null, null, null);
      }

      final data = await _loadData(user.uid);
      if (data == null) {
        return LoadResult(LoadStatus.deserializationError, null, null, null);
      }

      List<String> loadedList = [];

      Future<void> updateState<T>(dynamic state, List<T>? items, String name) async {
        await state.clear();
        if (items?.isNotEmpty ?? false) {
          await state.addAll(items!);
          loadedList.add("$name loaded: ${items.length}");
        }
      }

      await updateState(manager.exercisesState, data.result!.exercises, "Exercises");
      await updateState(manager.trainingPlanState, data.result!.plans, "Plans");
      await updateState(manager.trainingHistoryState, data.result!.history, "History");
      await updateState(manager.reportTableState, data.result!.tables, "Tables");
      await updateState(manager.reportState, data.result!.reports, "Reports");

      logger.i(loadedList.join("\n"));

      logger.i("Data loaded successfully for user ${user.uid}");
      return LoadResult(LoadStatus.success, data.timestamp, data.lastDataHash, data.result);
    } catch (e, st) {
      logger.e("Error loading data", error: e, stackTrace: st);
      return LoadResult(LoadStatus.error, null, null, null);
    }
  }
}

// internals

Future<LoadResult?> _loadData(String uid) async {
  final firestore = FirebaseFirestore.instance;
  final docRef = firestore.collection("user_data").doc(uid);

  try {
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      logger.w("Document not found for UID: $uid");
      return null;
    }

    final dataMap = snapshot.data();
    if (dataMap == null) {
      logger.w("Document is empty for UID: $uid");
      return null;
    }

    final rawData = dataMap["data"];
    final rawHash = dataMap["data_hash"];
    final rawLength = dataMap["data_length"];
    final rawTimestamp = dataMap["timestamp"];

    if (rawData is! List || rawHash is! String || rawLength is! int || rawTimestamp is! Timestamp) {
      logger.w("Invalid Firestore data format for UID: $uid");
      return null;
    }

    final bytes = Uint8List.fromList(rawData.cast<int>());

    if (bytes.length != rawLength) {
      logger.w("Data length mismatch for UID: $uid");
      return null;
    }

    final result = Serializer.deserialize(bytes);
    final computedHash = _computeHash(result.jsonRaw);

    if (computedHash != rawHash) {
      logger.w("Hash mismatch for UID: $uid");
      return null;
    }

    return LoadResult(LoadStatus.success, rawTimestamp, rawHash, result);
  } catch (e, st) {
    logger.e("Failed to load data for UID: $uid", error: e, stackTrace: st);
    return null;
  }
}

Future<SaveResult> _saveBlob(Uint8List blob, String? lastHash, String newHash, String uid, [String? username, bool bypassHash = false]) async {
  final firestore = FirebaseFirestore.instance;
  final docRef = firestore.collection("user_data").doc(uid);
  SaveResult? result;
  try {
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final existing = snapshot.data();
      if (existing != null && !bypassHash) {
        final currentHash = existing["data_hash"];
        final currentTimestamp = existing["timestamp"];
        if (currentHash is String && currentHash != lastHash) {
          logger.w("Conflict detected. Local hash=$lastHash, remote hash=$currentHash");
          result = SaveResult(
            SaveStatus.desynchronized,
            currentTimestamp is Timestamp ? currentTimestamp : null,
            currentHash,
          );
          throw Exception("Desync detected");
        }
      }
      transaction.set(docRef, {
        "data": blob,
        "data_hash": newHash,
        "data_length": blob.length,
        "timestamp": FieldValue.serverTimestamp(),
        "username": username ?? "anonymous",
      });
    });
    if (result == null) {
      final snapshot = await docRef.get();
      final serverHash = snapshot["data_hash"];
      final serverTimestamp = snapshot["timestamp"];
      if (serverHash is String && serverTimestamp is Timestamp) {
        result = SaveResult(SaveStatus.success, serverTimestamp, serverHash);
      } else {
        result = SaveResult(SaveStatus.error, null, null);
      }
    }
    return result!;
  } catch (e) {
    if (e.toString().contains("Desync detected") && result != null) {
      return result!;
    }
    logger.e("Error saving blob with transaction", error: e);
    return SaveResult(SaveStatus.error, null, null);
  }
}

SerializationResult _getData(StateManager manager) {
  return Serializer.serialize([
    manager.exercisesState,
    manager.trainingPlanState,
    manager.trainingHistoryState,
    manager.reportTableState,
    manager.reportState,
  ]);
}

String _computeHash(String data) {
  final bytes = utf8.encode(data);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
