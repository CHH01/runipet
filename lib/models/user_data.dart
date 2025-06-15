class UserData {
  final String userId;
  final String nickname;
  final String? profileImage;
  final int coin;
  final Map<String, dynamic> inventory;
  final int petLevel;
  final int totalSteps;
  final double recentDistance;
  final int recentTime;
  final int recentKcal;

  UserData({
    required this.userId,
    required this.nickname,
    this.profileImage,
    required this.coin,
    required this.inventory,
    this.petLevel = 1,
    this.totalSteps = 0,
    this.recentDistance = 0.0,
    this.recentTime = 0,
    this.recentKcal = 0,
  });

  // 서버에서 데이터를 받아올 때 사용할 팩토리 메서드
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'],
      nickname: json['nickname'],
      profileImage: json['profile_image'],
      coin: json['coin'],
      inventory: json['inventory'] ?? {},
      petLevel: json['pet_level'] ?? 1,
      totalSteps: json['total_steps'] ?? 0,
      recentDistance: (json['recent_distance'] ?? 0.0).toDouble(),
      recentTime: json['recent_time'] ?? 0,
      recentKcal: json['recent_kcal'] ?? 0,
    );
  }

  // 서버로 데이터를 보낼 때 사용할 메서드
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nickname': nickname,
      'profile_image': profileImage,
      'coin': coin,
      'inventory': inventory,
      'pet_level': petLevel,
      'total_steps': totalSteps,
      'recent_distance': recentDistance,
      'recent_time': recentTime,
      'recent_kcal': recentKcal,
    };
  }

  // 아이템 구매 시 새로운 UserData 객체 생성
  UserData copyWith({
    String? userId,
    String? nickname,
    String? profileImage,
    int? coin,
    Map<String, dynamic>? inventory,
    int? petLevel,
    int? totalSteps,
    double? recentDistance,
    int? recentTime,
    int? recentKcal,
  }) {
    return UserData(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      coin: coin ?? this.coin,
      inventory: inventory ?? this.inventory,
      petLevel: petLevel ?? this.petLevel,
      totalSteps: totalSteps ?? this.totalSteps,
      recentDistance: recentDistance ?? this.recentDistance,
      recentTime: recentTime ?? this.recentTime,
      recentKcal: recentKcal ?? this.recentKcal,
    );
  }
} 