import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/theme_data.dart';

class ThemeService {
  final String baseUrl;

  ThemeService({required this.baseUrl});

  // 전체 테마 조회
  Future<List<ThemeData>> getThemes() async {
    final response = await http.get(Uri.parse('$baseUrl/themes'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ThemeData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load themes');
    }
  }

  // 특정 테마 조회
  Future<ThemeData> getTheme(int themeId) async {
    final response = await http.get(Uri.parse('$baseUrl/themes/$themeId'));
    
    if (response.statusCode == 200) {
      return ThemeData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load theme');
    }
  }
} 