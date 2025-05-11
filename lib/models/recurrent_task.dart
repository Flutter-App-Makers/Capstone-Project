class TimeRecord {
  final DateTime startTime;
  final Duration duration;

  TimeRecord({required this.startTime, required this.duration});

  Map<String, dynamic> toJson() => {
        'startTime': startTime.toIso8601String(),
        'duration': duration.inMilliseconds,
      };

  factory TimeRecord.fromJson(Map<String, dynamic> json) => TimeRecord(
        startTime: DateTime.parse(json['startTime']),
        duration: Duration(milliseconds: json['duration']),
      );
}

class RecurrentTask {
  final String id;
  final String title;
  final List<TimeRecord> records;

  RecurrentTask({
    required this.id,
    required this.title,
    this.records = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'records': records.map((r) => r.toJson()).toList(),
      };

  factory RecurrentTask.fromJson(Map<String, dynamic> json) => RecurrentTask(
        id: json['id'],
        title: json['title'],
        records: (json['records'] as List)
            .map((r) => TimeRecord.fromJson(r))
            .toList(),
      );
}