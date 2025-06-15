class ExerciseRecord {
  final int id;
  final DateTime startTime;
  final DateTime endTime;
  final double distance;
  final double calories;
  final int steps;
  final int? petId;
  final bool isAnomaly;
  final int duration;

  ExerciseRecord({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.calories,
    required this.steps,
    this.petId,
    this.isAnomaly = false,
    required this.duration,
  });

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) {
    return ExerciseRecord(
      id: json['id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      distance: (json['distance'] ?? 0.0).toDouble(),
      calories: (json['calories'] ?? 0.0).toDouble(),
      steps: json['steps'] ?? 0,
      petId: json['pet_id'],
      isAnomaly: json['is_anomaly'] ?? false,
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'distance': distance,
      'calories': calories,
      'steps': steps,
      'pet_id': petId,
      'is_anomaly': isAnomaly,
      'duration': duration,
    };
  }
} 