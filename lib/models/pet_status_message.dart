class PetStatusMessage {
  final int id;
  final String healthStatus;
  final int minFullness;
  final int maxFullness;
  final int minHappiness;
  final int maxHappiness;
  final String message;

  PetStatusMessage({
    required this.id,
    required this.healthStatus,
    required this.minFullness,
    required this.maxFullness,
    required this.minHappiness,
    required this.maxHappiness,
    required this.message,
  });

  factory PetStatusMessage.fromJson(Map<String, dynamic> json) {
    return PetStatusMessage(
      id: json['id'],
      healthStatus: json['health_status'],
      minFullness: json['min_fullness'],
      maxFullness: json['max_fullness'],
      minHappiness: json['min_happiness'],
      maxHappiness: json['max_happiness'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'health_status': healthStatus,
      'min_fullness': minFullness,
      'max_fullness': maxFullness,
      'min_happiness': minHappiness,
      'max_happiness': maxHappiness,
      'message': message,
    };
  }
} 