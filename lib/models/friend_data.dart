import 'exercise_data.dart';

class FriendData {
  final String id;
  final String name;
  final String? profileImage;
  final int level;
  final int totalSteps;
  final DateTime lastActive;
  final bool isOnline;
  final List<ExerciseData> recentExercises;

  FriendData({
    required this.id,
    required this.name,
    this.profileImage,
    required this.level,
    required this.totalSteps,
    required this.lastActive,
    required this.isOnline,
    required this.recentExercises,
  });

  factory FriendData.fromJson(Map<String, dynamic> json) {
    return FriendData(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
      level: json['level'] as int,
      totalSteps: json['totalSteps'] as int,
      lastActive: DateTime.parse(json['lastActive'] as String),
      isOnline: json['isOnline'] as bool,
      recentExercises: (json['recentExercises'] as List)
          .map((e) => ExerciseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'level': level,
      'totalSteps': totalSteps,
      'lastActive': lastActive.toIso8601String(),
      'isOnline': isOnline,
      'recentExercises': recentExercises.map((e) => e.toJson()).toList(),
    };
  }
} 