import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:fittrackr/database/entities/exercise.dart';
import 'package:fittrackr/database/entities/report_table.dart';
import 'package:fittrackr/database/entities/training_history.dart';
import 'package:fittrackr/database/entities/training_plan.dart';
import 'package:fittrackr/states/app_states.dart';
import 'package:fittrackr/states/base_list_state.dart';

class SerializationResult {
  final Uint8List compressed;
  final String json;

  SerializationResult(this.compressed, this.json);
}

class DeserializationResult {
  List<Exercise>? exercises;
  List<TrainingPlan>? plans;
  List<TrainingHistory>? history;
  List<ReportTable>? tables;
  List<Report>? reports;
  String jsonRaw;

  DeserializationResult(this.jsonRaw);
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

  static DeserializationResult deserialize(Uint8List compressed) {
    final jsonString = _unzipData(compressed);
    final Map<String, dynamic> map = jsonDecode(jsonString);
    final result = DeserializationResult(jsonString);

    result.exercises = _parseList<Exercise>(map, ExercisesState.key, (e) => Exercise.fromMap(e));
    result.plans = _parseList<TrainingPlan>(map, TrainingPlanState.key, (e) => TrainingPlan.fromMap(e));
    result.history = _parseList<TrainingHistory>(map, TrainingHistoryState.key, (e) => TrainingHistory.fromMap(e));
    result.tables = _parseList<ReportTable>(map, ReportTableState.key, (e) => ReportTable.fromMap(e));
    result.reports = _parseList<Report>(map, ReportState.key, (e) => Report.fromMap(e));
    
    return result;
  }

  static List<T> _parseList<T>(Map<String, dynamic> map, String key, T? Function(dynamic) converter) {
    final raw = map[key];
    if (raw is List) {
      return raw.map(converter).where((e) => e != null).cast<T>().toList();
    }
    return [];
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

  static String _unzipData(Uint8List compressedData) {
    final archive = ZipDecoder().decodeBytes(compressedData);

    final file = archive.findFile('data.bin');
    if (file == null) {
      throw Exception("File data.bin not found in ZIP");
    }

    final runes = file.content as List<int>;
    return String.fromCharCodes(runes);
  }
}
