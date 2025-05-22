class User {
  final int id;
  final String name;
  final String email;
  final int level;
  final String joinDate;

  User({required this.id, required this.name, required this.email, required this.level, required this.joinDate});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      level: json['level'],
      joinDate: json['join_date'],
    );
  }
}