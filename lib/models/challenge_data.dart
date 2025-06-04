class ChallengeData {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final int reward;
  final int current;
  final int goal;
  final bool completed;

  ChallengeData({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.reward,
    required this.current,
    required this.goal,
    this.completed = false,
  });

  factory ChallengeData.fromJson(Map<String, dynamic> json) {
    return ChallengeData(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      reward: json['reward'] as int,
      current: json['current'] as int,
      goal: json['goal'] as int,
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'reward': reward,
      'current': current,
      'goal': goal,
      'completed': completed,
    };
  }

  ChallengeData copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    int? reward,
    int? current,
    int? goal,
    bool? completed,
  }) {
    return ChallengeData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      reward: reward ?? this.reward,
      current: current ?? this.current,
      goal: goal ?? this.goal,
      completed: completed ?? this.completed,
    );
  }
} 