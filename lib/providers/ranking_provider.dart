import 'package:flutter/foundation.dart';

class RankingData {
  final String userId;
  final String name;
  final String? profileImage;
  final int level;
  final int totalSteps;
  final int totalDistance;
  final int totalCalories;
  final bool isFriend;
  final bool isMe;

  RankingData({
    required this.userId,
    required this.name,
    this.profileImage,
    required this.level,
    required this.totalSteps,
    required this.totalDistance,
    required this.totalCalories,
    required this.isFriend,
    required this.isMe,
  });

  factory RankingData.fromJson(Map<String, dynamic> json) {
    return RankingData(
      userId: json['userId'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
      level: json['level'] as int,
      totalSteps: json['totalSteps'] as int,
      totalDistance: json['totalDistance'] as int,
      totalCalories: json['totalCalories'] as int,
      isFriend: json['isFriend'] as bool,
      isMe: json['isMe'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profileImage': profileImage,
      'level': level,
      'totalSteps': totalSteps,
      'totalDistance': totalDistance,
      'totalCalories': totalCalories,
      'isFriend': isFriend,
      'isMe': isMe,
    };
  }
}

class RankingProvider with ChangeNotifier {
  List<RankingData> _rankings = [];
  List<RankingData> _friendRankings = [];
  List<RankingData> _weeklyRankings = [];
  List<RankingData> _monthlyRankings = [];
  bool _isLoading = false;
  String? _error;
  String _currentFilter = '전체';

  List<RankingData> get rankings => _rankings;
  List<RankingData> get friendRankings => _friendRankings;
  List<RankingData> get weeklyRankings => _weeklyRankings;
  List<RankingData> get monthlyRankings => _monthlyRankings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentFilter => _currentFilter;

  Future<void> loadRankings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이
      
      // 임시 데이터
      _rankings = [
        RankingData(
          userId: '1',
          name: '이영희',
          level: 25,
          totalSteps: 20000,
          totalDistance: 15000,
          totalCalories: 800,
          isFriend: true,
          isMe: false,
        ),
        RankingData(
          userId: '2',
          name: '김철수',
          level: 20,
          totalSteps: 15000,
          totalDistance: 12000,
          totalCalories: 600,
          isFriend: true,
          isMe: false,
        ),
        // ... 더 많은 임시 데이터
      ];

      // 친구 랭킹 필터링
      _friendRankings = _rankings.where((r) => r.isFriend).toList();
      
      // 주간/월간 랭킹은 API에서 받아와야 함
      _weeklyRankings = _rankings;
      _monthlyRankings = _rankings;

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  List<RankingData> getCurrentRankings() {
    switch (_currentFilter) {
      case '친구':
        return _friendRankings;
      case '주간':
        return _weeklyRankings;
      case '월간':
        return _monthlyRankings;
      default:
        return _rankings;
    }
  }

  List<RankingData> getTopRankers() {
    final currentRankings = getCurrentRankings();
    return currentRankings.take(3).toList();
  }

  RankingData getMyRanking() {
    return _rankings.firstWhere(
      (r) => r.isMe,
      orElse: () => RankingData(
        name: 'Me',
        userId: 'me',
        level: 1,
        totalSteps: 0,
        totalDistance: 0,
        totalCalories: 0,
        isMe: true,
        isFriend: false,
      ),
    );
  }
} 