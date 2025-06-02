class PetData {
  final String id;
  final String name;
  final String type;
  final String imagePath;
  final int satiety;
  final int happiness;
  final int health;
  final int level;
  final int exp;
  final int maxExp;

  PetData({
    required this.id,
    required this.name,
    required this.type,
    required this.imagePath,
    required this.satiety,
    required this.happiness,
    required this.health,
    required this.level,
    required this.exp,
    this.maxExp = 5000,
  });

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      imagePath: json['imagePath'] as String,
      satiety: json['satiety'] as int,
      happiness: json['happiness'] as int,
      health: json['health'] as int,
      level: json['level'] as int,
      exp: json['exp'] as int,
      maxExp: json['maxExp'] as int? ?? 5000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'imagePath': imagePath,
      'satiety': satiety,
      'happiness': happiness,
      'health': health,
      'level': level,
      'exp': exp,
      'maxExp': maxExp,
    };
  }

  PetData copyWith({
    String? id,
    String? name,
    String? type,
    String? imagePath,
    int? satiety,
    int? happiness,
    int? health,
    int? level,
    int? exp,
    int? maxExp,
  }) {
    return PetData(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      imagePath: imagePath ?? this.imagePath,
      satiety: satiety ?? this.satiety,
      happiness: happiness ?? this.happiness,
      health: health ?? this.health,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      maxExp: maxExp ?? this.maxExp,
    );
  }
} 