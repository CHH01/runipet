import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/challenge_data.dart';
import 'api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChallengeService {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage;
  final String _baseUrl;

  ChallengeService(this._apiService, this._secureStorage, this._baseUrl);

  Future<List<Map<String, dynamic>>> getChallenges() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print('도전과제 목록 가져오기 실패: 토큰이 없습니다.');
        return [];
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/challenges'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('도전과제 응답: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null) {
          print('도전과제 데이터가 null입니다.');
          return [];
        }
        
        if (data is Map<String, dynamic> && data.containsKey('challenges')) {
          final List<dynamic> challenges = data['challenges'];
          return challenges.map((challenge) => Map<String, dynamic>.from(challenge)).toList();
        } else if (data is List) {
          return data.map((challenge) => Map<String, dynamic>.from(challenge)).toList();
        }
        
        print('도전과제 데이터 형식이 올바르지 않습니다: $data');
        return [];
      } else if (response.statusCode == 422) {
        print('도전과제 목록이 비어있습니다.');
        return [];
      } else {
        print('도전과제 목록을 가져오는데 실패했습니다: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('도전과제 목록 가져오기 실패: $e');
      return [];
    }
  }

  Future<void> initChallenges() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print('도전과제 초기화 실패: 토큰이 없습니다.');
        return;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/challenges/init'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({}),
      );

      print('도전과제 초기화 응답: ${response.statusCode} - ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('도전과제 초기화에 실패했습니다: ${response.statusCode}');
      }
    } catch (e) {
      print('도전과제 초기화 실패: $e');
    }
  }

  Future<void> updateProgress(int challengeId, int progress) async {
    try {
      await _apiService.updateChallengeProgress(challengeId.toString(), progress);
    } catch (e) {
      print('Failed to update challenge progress: $e');
      rethrow;
    }
  }

  Future<void> updateChallenge(String challengeId, Map<String, dynamic> data) async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('토큰이 없습니다.');
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/challenges/$challengeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('도전과제 업데이트에 실패했습니다.');
      }
    } catch (e) {
      print('도전과제 업데이트 실패: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> claimReward(int challengeId) async {
    final response = await _apiService.post(
      '/challenges/$challengeId/reward',
      {},
    );
    return {
      'reward': response['reward'],
      'total_coins': response['total_coins'],
    };
  }
} 