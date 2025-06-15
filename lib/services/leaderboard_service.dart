import 'dart:convert';
import '../models/leaderboard_entry.dart';
import 'api_service.dart';

class LeaderboardService {
  final ApiService _apiService;

  LeaderboardService(this._apiService);

  Future<List<LeaderboardEntry>> getLeaderboard() async {
    try {
      final response = await _apiService.get('/leaderboard');
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'];
        return data.map((json) => LeaderboardEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (e) {
      throw Exception('Failed to load leaderboard: $e');
    }
  }
} 