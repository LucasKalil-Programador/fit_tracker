class Timer {
  int? id;
  final DateTime? startTime;
  final DateTime? pausedTime;
  final bool paused;

  Timer({
    this.id,
    required this.startTime,
    required this.pausedTime,
    required this.paused,
  });

  @override
  String toString() {
    return 'Timer(id: $id, startTime: $startTime, pausedTime: $pausedTime, paused: $paused)';
  }

  static Timer fromMap(Map<String, Object?> e) {
    DateTime? startTime;
    DateTime? pausedTime;
    if(e['start_time'] is int) {
      startTime = DateTime.fromMillisecondsSinceEpoch(e['start_time'] as int);
    }

    if(e['paused_time'] is int) {
      pausedTime = DateTime.fromMillisecondsSinceEpoch(e['paused_time'] as int);
    }

    return Timer(
      id: e['id'] as int,
      startTime: startTime,
      pausedTime: pausedTime,
      paused: (e['paused'] as int) != 0,
    );
  }
}