class PitStopData {
  final int id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String reward_type;
  final int reward_value;

  PitStopData({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.reward_type,
    required this.reward_value,
  });

  factory PitStopData.fromJson(Map<String, dynamic> json) {
    return PitStopData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      reward_type: json['reward_type'],
      reward_value: json['reward_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'reward_type': reward_type,
      'reward_value': reward_value,
    };
  }
} 