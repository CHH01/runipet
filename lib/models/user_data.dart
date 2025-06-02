class UserData {
  final int coin;
  final Map<String, int> inventory;

  UserData({
    required this.coin,
    required this.inventory,
  });

  // 서버에서 데이터를 받아올 때 사용할 팩토리 메서드
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      coin: json['coin'] as int,
      inventory: Map<String, int>.from(json['inventory'] as Map),
    );
  }

  // 서버로 데이터를 보낼 때 사용할 메서드
  Map<String, dynamic> toJson() {
    return {
      'coin': coin,
      'inventory': inventory,
    };
  }

  // 아이템 구매 시 새로운 UserData 객체 생성
  UserData copyWith({
    int? coin,
    Map<String, int>? inventory,
  }) {
    return UserData(
      coin: coin ?? this.coin,
      inventory: inventory ?? this.inventory,
    );
  }
} 