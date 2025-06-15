import 'exercise_record.dart';

class FriendData {
  final String userId;
  final String username;
  final String? profileImage;
  final int level;
  final int experience;
  final int steps;
  final bool isOnline;
  final String? lastActive;

  FriendData({
    required this.userId,
    required this.username,
    this.profileImage,
    required this.level,
    required this.experience,
    required this.steps,
    this.isOnline = false,
    this.lastActive,
  });

  factory FriendData.fromJson(Map<String, dynamic> json) {
    return FriendData(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      profileImage: json['profile_image'] as String?,
      level: json['level'] as int? ?? 1,
      experience: json['experience'] as int? ?? 0,
      steps: json['steps'] as int? ?? 0,
      isOnline: json['is_online'] as bool? ?? false,
      lastActive: json['last_active'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'profile_image': profileImage,
      'level': level,
      'experience': experience,
      'steps': steps,
      'is_online': isOnline,
      'last_active': lastActive,
    };
  }

  String get friendId => userId;
} 