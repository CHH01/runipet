class ChallengeData {
  final int id;
  final String name;
  final String description;
  final String iconPath;
  final int current;
  final int goal;
  final bool completed;
  final bool reward_claimed;
  final String reward_type;
  final int reward_value;

  ChallengeData({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.current,
    required this.goal,
    required this.completed,
    required this.reward_claimed,
    required this.reward_type,
    required this.reward_value,
  });

  factory ChallengeData.fromJson(Map<String, dynamic> json) {
    return ChallengeData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconPath: json['icon_path'],
      current: json['current'],
      goal: json['goal'],
      completed: json['completed'],
      reward_claimed: json['reward_claimed'],
      reward_type: json['reward_type'],
      reward_value: json['reward_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_path': iconPath,
      'current': current,
      'goal': goal,
      'completed': completed,
      'reward_claimed': reward_claimed,
      'reward_type': reward_type,
      'reward_value': reward_value,
    };
  }

  ChallengeData copyWith({
    int? id,
    String? name,
    String? description,
    String? iconPath,
    int? current,
    int? goal,
    bool? completed,
    bool? reward_claimed,
    String? reward_type,
    int? reward_value,
  }) {
    return ChallengeData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      current: current ?? this.current,
      goal: goal ?? this.goal,
      completed: completed ?? this.completed,
      reward_claimed: reward_claimed ?? this.reward_claimed,
      reward_type: reward_type ?? this.reward_type,
      reward_value: reward_value ?? this.reward_value,
    );
  }
} 