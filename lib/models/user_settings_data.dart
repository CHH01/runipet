class UserSettingsData {
  final int user_id;
  final int goal_steps;
  final bool hunger_notify;
  final bool growth_notify;
  final bool motivation_notify;
  final bool friend_notify;
  final bool leaderboard_notify;

  UserSettingsData({
    required this.user_id,
    required this.goal_steps,
    required this.hunger_notify,
    required this.growth_notify,
    required this.motivation_notify,
    required this.friend_notify,
    required this.leaderboard_notify,
  });

  factory UserSettingsData.fromJson(Map<String, dynamic> json) {
    return UserSettingsData(
      user_id: json['user_id'],
      goal_steps: json['goal_steps'] ?? 10000,
      hunger_notify: json['hunger_notify'] ?? true,
      growth_notify: json['growth_notify'] ?? true,
      motivation_notify: json['motivation_notify'] ?? true,
      friend_notify: json['friend_notify'] ?? true,
      leaderboard_notify: json['leaderboard_notify'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'goal_steps': goal_steps,
      'hunger_notify': hunger_notify,
      'growth_notify': growth_notify,
      'motivation_notify': motivation_notify,
      'friend_notify': friend_notify,
      'leaderboard_notify': leaderboard_notify,
    };
  }

  UserSettingsData copyWith({
    int? user_id,
    int? goal_steps,
    bool? hunger_notify,
    bool? growth_notify,
    bool? motivation_notify,
    bool? friend_notify,
    bool? leaderboard_notify,
  }) {
    return UserSettingsData(
      user_id: user_id ?? this.user_id,
      goal_steps: goal_steps ?? this.goal_steps,
      hunger_notify: hunger_notify ?? this.hunger_notify,
      growth_notify: growth_notify ?? this.growth_notify,
      motivation_notify: motivation_notify ?? this.motivation_notify,
      friend_notify: friend_notify ?? this.friend_notify,
      leaderboard_notify: leaderboard_notify ?? this.leaderboard_notify,
    );
  }
} 