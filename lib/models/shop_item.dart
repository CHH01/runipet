class ShopItem {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final int price;
  final Map<String, dynamic> effect;
  final String type;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.effect,
    required this.type,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      price: json['price'] as int,
      effect: json['effect'] as Map<String, dynamic>,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'price': price,
      'effect': effect,
      'type': type,
    };
  }
} 