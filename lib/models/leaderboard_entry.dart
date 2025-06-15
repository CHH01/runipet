class LeaderboardEntry {
  final String userId;
  final String nickname;
  final int totalSteps;
  final int totalExperience;
  final int rank;
  final String? profileImage;
  final String rankIcon;

  LeaderboardEntry({
    required this.userId,
    required this.nickname,
    required this.totalSteps,
    required this.totalExperience,
    required this.rank,
    this.profileImage,
    required this.rankIcon,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'],
      nickname: json['nickname'],
      totalSteps: json['total_steps'],
      totalExperience: json['total_experience'],
      rank: json['rank'],
      profileImage: json['profile_image'],
      rankIcon: json['rank_icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nickname': nickname,
      'total_steps': totalSteps,
      'total_experience': totalExperience,
      'rank': rank,
      'profile_image': profileImage,
      'rank_icon': rankIcon,
    };
  }
} 