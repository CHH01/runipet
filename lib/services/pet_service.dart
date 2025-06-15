import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet_stage_data.dart';
import '../models/pet_status_message.dart';

class PetService {
  final String baseUrl;

  PetService({required this.baseUrl});

  // 모든 펫 스테이지 조회
  Future<List<PetStageData>> getPetStages() async {
    final response = await http.get(Uri.parse('$baseUrl/pet-stages'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PetStageData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pet stages');
    }
  }

  // 특정 펫 스테이지 조회
  Future<PetStageData> getPetStage(int stageId) async {
    final response = await http.get(Uri.parse('$baseUrl/pet-stages/$stageId'));
    
    if (response.statusCode == 200) {
      return PetStageData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load pet stage');
    }
  }

  // 모든 상태 메시지 조회
  Future<List<PetStatusMessage>> getStatusMessages() async {
    final response = await http.get(Uri.parse('$baseUrl/status-messages'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PetStatusMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load status messages');
    }
  }

  // 조건에 맞는 상태 메시지 필터링
  Future<List<PetStatusMessage>> filterStatusMessages({
    String? healthStatus,
    int? fullness,
    int? happiness,
  }) async {
    final queryParams = <String, String>{};
    if (healthStatus != null) queryParams['health_status'] = healthStatus;
    if (fullness != null) queryParams['fullness'] = fullness.toString();
    if (happiness != null) queryParams['happiness'] = happiness.toString();

    final uri = Uri.parse('$baseUrl/status-messages/filter').replace(queryParameters: queryParams);
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PetStatusMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to filter status messages');
    }
  }
} 