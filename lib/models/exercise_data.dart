class ExerciseData {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final double distance;
  final int duration;
  final int calories;
  final int steps;
  final String type;
  final Map<String, dynamic>? route;

  ExerciseData({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.distance,
    required this.duration,
    required this.calories,
    required this.steps,
    required this.type,
    this.route,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      distance: json['distance'] as double,
      duration: json['duration'] as int,
      calories: json['calories'] as int,
      steps: json['steps'] as int,
      type: json['type'] as String,
      route: json['route'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'distance': distance,
      'duration': duration,
      'calories': calories,
      'steps': steps,
      'type': type,
      'route': route,
    };
  }

  ExerciseData copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    double? distance,
    int? duration,
    int? calories,
    int? steps,
    String? type,
    Map<String, dynamic>? route,
  }) {
    return ExerciseData(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      calories: calories ?? this.calories,
      steps: steps ?? this.steps,
      type: type ?? this.type,
      route: route ?? this.route,
    );
  }
} 