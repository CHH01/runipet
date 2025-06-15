import '../models/exercise_record.dart';
import 'api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ExerciseService {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage;
  final String _baseUrl;

  ExerciseService(this._apiService, this._secureStorage, this._baseUrl);

  Future<ExerciseRecord?> getRecentExercise() async {
    try {
      final response = await _apiService.get('/exercise/records/recent');
      if (response['record'] != null) {
        return ExerciseRecord.fromJson(response['record']);
      }
      return null;
    } catch (e) {
      print('최근 운동 기록을 불러오는데 실패했습니다: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getExerciseHistory() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print('운동 기록 가져오기 실패: 토큰이 없습니다.');
        return [];
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/exercises'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('운동 기록 응답: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null) {
          print('운동 기록 데이터가 null입니다.');
          return [];
        }
        
        if (data is Map<String, dynamic> && data.containsKey('records')) {
          final List<dynamic> records = data['records'];
          return records.map((record) => Map<String, dynamic>.from(record)).toList();
        } else if (data is List) {
          return data.map((record) => Map<String, dynamic>.from(record)).toList();
        }
        
        print('운동 기록 데이터 형식이 올바르지 않습니다: $data');
        return [];
      } else if (response.statusCode == 404) {
        print('운동 기록 엔드포인트를 찾을 수 없습니다.');
        return [];
      } else {
        print('운동 기록을 가져오는데 실패했습니다: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('운동 기록 가져오기 실패: $e');
      return [];
    }
  }

  Future<void> saveExercise(Map<String, dynamic> exerciseData) async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print('운동 기록 저장 실패: 토큰이 없습니다.');
        return;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/exercises'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(exerciseData),
      );

      print('운동 기록 저장 응답: ${response.statusCode} - ${response.body}');

      if (response.statusCode != 201 && response.statusCode != 200) {
        print('운동 기록 저장에 실패했습니다: ${response.statusCode}');
      }
    } catch (e) {
      print('운동 기록 저장 실패: $e');
    }
  }
} 