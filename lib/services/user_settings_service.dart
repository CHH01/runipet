import '../models/user_settings_data.dart';
import 'api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSettingsService {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage;
  final String _baseUrl;

  UserSettingsService(this._apiService, this._secureStorage, this._baseUrl);

  // 사용자 설정 가져오기
  Future<UserSettingsData> getSettings() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('토큰이 없습니다.');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/user/settings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserSettingsData.fromJson(data);
      } else {
        throw Exception('설정을 가져오는데 실패했습니다.');
      }
    } catch (e) {
      print('설정 가져오기 실패: $e');
      rethrow;
    }
  }

  // 사용자 설정 업데이트
  Future<UserSettingsData> updateSettings(UserSettingsData settings) async {
    try {
      final response = await _apiService.put('/settings', settings.toJson());
      return UserSettingsData.fromJson(response);
    } catch (e) {
      throw Exception('설정 업데이트 실패: $e');
    }
  }

  Future<UserSettingsData> updateStepGoal(int goal) async {
    try {
      final response = await _apiService.put('/settings', {'goal_steps': goal});
      return UserSettingsData.fromJson(response);
    } catch (e) {
      throw Exception('걸음 목표 업데이트 실패: $e');
    }
  }

  Future<UserSettingsData> updateHungerNotify(bool value) async {
    try {
      final response = await _apiService.put('/settings', {'hunger_notify': value});
      return UserSettingsData.fromJson(response);
    } catch (e) {
      throw Exception('배고픔 알림 설정 실패: $e');
    }
  }

  Future<UserSettingsData> updateGrowthNotify(bool value) async {
    try {
      final response = await _apiService.put('/settings', {'growth_notify': value});
      return UserSettingsData.fromJson(response);
    } catch (e) {
      throw Exception('성장 알림 설정 실패: $e');
    }
  }

  Future<UserSettingsData> updateMotivationNotify(bool value) async {
    try {
      final response = await _apiService.put('/settings', {'motivation_notify': value});
      return UserSettingsData.fromJson(response);
    } catch (e) {
      throw Exception('동기부여 알림 설정 실패: $e');
    }
  }

  Future<UserSettingsData> updateFriendNotify(bool value) async {
    try {
      final response = await _apiService.put('/settings', {'friend_notify': value});
      return UserSettingsData.fromJson(response);
    } catch (e) {
      throw Exception('친구 알림 설정 실패: $e');
    }
  }

  Future<UserSettingsData> updateLeaderboardNotify(bool value) async {
    try {
      final response = await _apiService.put('/settings', {'leaderboard_notify': value});
      return UserSettingsData.fromJson(response);
    } catch (e) {
      throw Exception('리더보드 알림 설정 실패: $e');
    }
  }
} 