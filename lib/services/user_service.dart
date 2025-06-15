import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_data.dart';

class UserService {
  final String baseUrl = 'http://10.0.2.2:5000';
  late SharedPreferences _prefs;

  UserService() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<Map<String, String>> _getHeaders() async {
    await _initPrefs();
    final token = _prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<UserData> getUserProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserData.fromJson(data);
      } else {
        throw Exception('프로필을 불러오는데 실패했습니다.');
      }
    } catch (e) {
      throw Exception('프로필을 불러오는데 실패했습니다: $e');
    }
  }

  Future<void> updateNickname(String newNickname) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/profile/nickname'),
        headers: headers,
        body: json.encode({'nickname': newNickname}),
      );

      if (response.statusCode != 200) {
        throw Exception('닉네임 변경에 실패했습니다.');
      }
    } catch (e) {
      throw Exception('닉네임 변경에 실패했습니다: $e');
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      final headers = await _getHeaders();
      final file = File(imagePath);
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/profile/image'),
      );

      request.headers.addAll(headers);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          file.path,
        ),
      );

      final response = await request.send();
      if (response.statusCode != 200) {
        throw Exception('프로필 이미지 변경에 실패했습니다.');
      }
    } catch (e) {
      throw Exception('프로필 이미지 변경에 실패했습니다: $e');
    }
  }
} 