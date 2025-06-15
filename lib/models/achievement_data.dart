class AchievementData {
  final int id;
  final String name;
  final String description;
  final String condition;
  final String imageUrl;
  final String reward_type;
  final int reward_value;
  final DateTime? achievedAt;

  AchievementData({
    required this.id,
    required this.name,
    required this.description,
    required this.condition,
    required this.imageUrl,
    required this.reward_type,
    required this.reward_value,
    this.achievedAt,
  });

  factory AchievementData.fromJson(Map<String, dynamic> json) {
    return AchievementData(
      id: json['id'] ?? json['achievement_id'],
      name: json['name'],
      description: json['description'],
      condition: json['condition'],
      imageUrl: json['image_url'],
      reward_type: json['reward_type'],
      reward_value: json['reward_value'],
      achievedAt: json['achieved_at'] != null 
          ? DateTime.parse(json['achieved_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'condition': condition,
      'image_url': imageUrl,
      'reward_type': reward_type,
      'reward_value': reward_value,
      'achieved_at': achievedAt?.toIso8601String(),
    };
  }

  bool get isAchieved => achievedAt != null;
} 