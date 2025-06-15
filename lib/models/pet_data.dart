class PetData {
  final int petId;
  final String nickname;
  final String type;
  final int level;
  final int exp;
  final int fullness;
  final int happiness;
  final String healthStatus;
  final int stageId;
  final int statusMessageId;

  PetData({
    required this.petId,
    required this.nickname,
    required this.type,
    required this.level,
    required this.exp,
    required this.fullness,
    required this.happiness,
    required this.healthStatus,
    required this.stageId,
    required this.statusMessageId,
  });

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      petId: json['pet_id'],
      nickname: json['nickname'],
      type: json['type'],
      level: json['level'],
      exp: json['exp'],
      fullness: json['fullness'],
      happiness: json['happiness'],
      healthStatus: json['health_status'],
      stageId: json['stage_id'],
      statusMessageId: json['status_message_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pet_id': petId,
      'nickname': nickname,
      'type': type,
      'level': level,
      'exp': exp,
      'fullness': fullness,
      'happiness': happiness,
      'health_status': healthStatus,
      'stage_id': stageId,
      'status_message_id': statusMessageId,
    };
  }

  PetData copyWith({
    int? petId,
    String? nickname,
    String? type,
    int? level,
    int? exp,
    int? fullness,
    int? happiness,
    String? healthStatus,
    int? stageId,
    int? statusMessageId,
  }) {
    return PetData(
      petId: petId ?? this.petId,
      nickname: nickname ?? this.nickname,
      type: type ?? this.type,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      fullness: fullness ?? this.fullness,
      happiness: happiness ?? this.happiness,
      healthStatus: healthStatus ?? this.healthStatus,
      stageId: stageId ?? this.stageId,
      statusMessageId: statusMessageId ?? this.statusMessageId,
    );
  }
} 