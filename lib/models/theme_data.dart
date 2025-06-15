enum Season {
  spring,
  summer,
  fall,
  winter
}

class ThemeData {
  final int id;
  final String name;
  final String description;
  final Season season;
  final String imagePath;

  ThemeData({
    required this.id,
    required this.name,
    required this.description,
    required this.season,
    required this.imagePath,
  });

  factory ThemeData.fromJson(Map<String, dynamic> json) {
    return ThemeData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      season: Season.values.firstWhere(
        (e) => e.toString().split('.').last == json['season'],
        orElse: () => Season.spring,
      ),
      imagePath: 'assets/images/${json['season']}.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'season': season.toString().split('.').last,
      'image_path': imagePath,
    };
  }

  static List<ThemeData> get defaultThemes => [
    ThemeData(
      id: 1,
      name: '봄 테마',
      description: '따뜻한 봄의 분위기를 느껴보세요',
      season: Season.spring,
      imagePath: 'assets/images/spring.png',
    ),
    ThemeData(
      id: 2,
      name: '여름 테마',
      description: '시원한 여름의 분위기를 느껴보세요',
      season: Season.summer,
      imagePath: 'assets/images/summer.png',
    ),
    ThemeData(
      id: 3,
      name: '가을 테마',
      description: '낭만적인 가을의 분위기를 느껴보세요',
      season: Season.fall,
      imagePath: 'assets/images/fall.png',
    ),
    ThemeData(
      id: 4,
      name: '겨울 테마',
      description: '설레는 겨울의 분위기를 느껴보세요',
      season: Season.winter,
      imagePath: 'assets/images/winter.png',
    ),
  ];
} 