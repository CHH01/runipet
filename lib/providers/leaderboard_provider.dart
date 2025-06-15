import 'package:flutter/foundation.dart';
import '../models/leaderboard_entry.dart';
import '../services/leaderboard_service.dart';

class LeaderboardProvider extends ChangeNotifier {
  final LeaderboardService _leaderboardService;
  final List<LeaderboardEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  LeaderboardProvider(this._leaderboardService);

  List<LeaderboardEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLeaderboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _leaderboardService.getLeaderboard();
      _entries.clear();
      _entries.addAll(response);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 