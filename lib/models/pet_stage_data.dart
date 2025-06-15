class PetStageData {
  final int id;
  final String type;
  final String stageName;
  final String imageUrl;
  final int minLevel;
  final int maxLevel;

  PetStageData({
    required this.id,
    required this.type,
    required this.stageName,
    required this.imageUrl,
    required this.minLevel,
    required this.maxLevel,
  });

  factory PetStageData.fromJson(Map<String, dynamic> json) {
    return PetStageData(
      id: json['id'],
      type: json['type'],
      stageName: json['stage_name'],
      imageUrl: json['image_url'],
      minLevel: json['min_level'],
      maxLevel: json['max_level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'stage_name': stageName,
      'image_url': imageUrl,
      'min_level': minLevel,
      'max_level': maxLevel,
    };
  }
} 