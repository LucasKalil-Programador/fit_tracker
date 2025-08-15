import 'package:fittrackr/database/proxy/exercise_proxy.dart';
import 'package:fittrackr/database/proxy/metadata_proxy.dart';
import 'package:fittrackr/database/proxy/report_proxy.dart';
import 'package:fittrackr/database/proxy/report_table_proxy.dart';
import 'package:fittrackr/database/proxy/training_history_proxy.dart';
import 'package:fittrackr/database/proxy/training_plan_proxy.dart';
import 'package:synchronized/synchronized.dart';


// Proxy

class DatabaseProxy {
  DatabaseProxy._internal();

  static final DatabaseProxy _instance = DatabaseProxy._internal();
  static DatabaseProxy get instance => _instance;
  
  final sharedLock = Lock();

  final exercise         = ExerciseProxy();
  final trainingPlan     = TrainingPlanProxy();  
  final metadata         = MetadataProxy();
  final trainingHistory  = TrainingHistoryProxy();
  late final reportTable = ReportTableProxy(sharedLock);
  late final report      = ReportProxy(sharedLock);
}