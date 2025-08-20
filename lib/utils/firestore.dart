
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:fittrackr/states/state_manager.dart';
import 'package:crypto/crypto.dart';

enum SaveStatus { error, success, disconnected, desynchronized }

class SaveResult {
  SaveStatus status;
  Timestamp? timestamp;
  String? lastDataHash;

  SaveResult(this.status, this.timestamp, this.lastDataHash);
}

class FirestoreUtils {
  static Future<SaveResult> saveData(StateManager manager, String? lastHash) async {
    try {
      final serializationResult = _getData(manager);
      final json = serializationResult.json;
      final data = serializationResult.compressed;
      final newHash = _computeHash(json);

      final user = manager.authState.user;
      if (user == null) {
        return SaveResult(SaveStatus.disconnected, null, null);
      }

      final result = await _saveBlob(
        data,
        lastHash,
        newHash,
        user.uid,
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

  static Future<SaveResult> _saveBlob(Uint8List blob, String? lastHash, String newHash, String uid) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection("user_data").doc(uid);

    SaveResult? result;

    try {
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final existing = snapshot.data();

        if (existing != null) {
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
          "timestamp": FieldValue.serverTimestamp(),
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

String _computeHash(String json) {
  final bytes = utf8.encode(json);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
