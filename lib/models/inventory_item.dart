class InventoryItem {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final Map<String, dynamic> effect;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.effect,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      effect: json['effect'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'effect': effect,
    };
  }
} 