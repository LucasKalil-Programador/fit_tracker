import 'package:fittrackr/states/state_manager.dart';

extension StateManagerExtension on StateManager {
  Future<DateTime?> getLocalTimeStamp() async {
    final localTimeStamp = await safeStorage.read(key: lastTimeStampKeyy);
    if(localTimeStamp != null) {
      return DateTime.parse(localTimeStamp);
    }
    return null;
  }

  Future<void> setLocalTimeStamp(DateTime datetime) => safeStorage.write(
    key: lastTimeStampKeyy,
    value: datetime.toIso8601String(),
  );

  Future<String?> getLastHash() => safeStorage.read(key: lastUpdateKeyy);
  
  Future<void> setLastHash(String hash) => safeStorage.write(key: lastUpdateKeyy, value: hash);
}
