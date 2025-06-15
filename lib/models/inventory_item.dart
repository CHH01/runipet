class InventoryItem {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final String effect;
  final String category;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.effect,
    required this.category,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['image_path'],
      effect: json['effect'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_path': imagePath,
      'effect': effect,
      'category': category,
    };
  }
} 