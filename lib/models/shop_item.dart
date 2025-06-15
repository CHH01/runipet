class ShopItem {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final int price;
  final String type;
  final Map<String, dynamic> effect;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.type,
    required this.effect,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['image_path'],
      price: json['price'],
      type: json['type'],
      effect: json['effect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_path': imagePath,
      'price': price,
      'type': type,
      'effect': effect,
    };
  }
} 