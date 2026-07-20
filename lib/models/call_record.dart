/// A record of a past Safe Call, persisted locally (and backend-syncable).
class CallRecord {
  final String typeLabel;
  final int guardianCount;
  final int durationSeconds;
  final bool policeAdded;
  final int startedAtMs; // epoch millis

  const CallRecord({
    required this.typeLabel,
    required this.guardianCount,
    required this.durationSeconds,
    required this.policeAdded,
    required this.startedAtMs,
  });

  String get durationLabel {
    final m = (durationSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Map<String, dynamic> toJson() => {
        'typeLabel': typeLabel,
        'guardianCount': guardianCount,
        'durationSeconds': durationSeconds,
        'policeAdded': policeAdded,
        'startedAtMs': startedAtMs,
      };

  factory CallRecord.fromJson(Map<String, dynamic> j) => CallRecord(
        typeLabel: j['typeLabel'] as String? ?? 'Safe Call',
        guardianCount: j['guardianCount'] as int? ?? 0,
        durationSeconds: j['durationSeconds'] as int? ?? 0,
        policeAdded: j['policeAdded'] as bool? ?? false,
        startedAtMs: j['startedAtMs'] as int? ?? 0,
      );
}
