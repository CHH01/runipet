import 'dart:convert';
import '../models/pitstop_data.dart';
import 'api_service.dart';

class PitStopService {
  final ApiService _apiService;

  PitStopService(this._apiService);

  Future<List<PitStopData>> getPitStops() async {
    try {
      final response = await _apiService.get('/pitstops');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => PitStopData.fromJson(json)).toList();
    } catch (e) {
      throw Exception('피트스탑 목록을 불러오는데 실패했습니다: $e');
    }
  }

  Future<PitStopData> getPitStop(int pitStopId) async {
    try {
      final response = await _apiService.get('/pitstops/$pitStopId');
      return PitStopData.fromJson(response);
    } catch (e) {
      throw Exception('피트스탑 정보를 불러오는데 실패했습니다: $e');
    }
  }

  Future<Map<String, dynamic>> claimReward(int pitStopId) async {
    try {
      final response = await _apiService.post('/pitstops/$pitStopId/reward', {});
      return response;
    } catch (e) {
      throw Exception('보상 수령에 실패했습니다: $e');
    }
  }
} 