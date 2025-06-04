import 'package:flutter/foundation.dart';
import '../models/challenge_data.dart';

class ChallengeProvider with ChangeNotifier {
  List<ChallengeData> _challenges = [];
  bool _isLoading = false;
  String? _error;

  List<ChallengeData> get challenges => _challenges;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChallenges() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이
      _challenges = [
        ChallengeData(
          id: 'first_exercise',
          name: '첫 운동',
          description: '운동 시작하기',
          iconPath: 'assets/images/icons/first_exercise.png',
          reward: 100,
          current: 0,
          goal: 1,
        ),
        ChallengeData(
          id: '50km',
          name: '50km 달리기',
          description: '누적 거리 50km 달성',
          iconPath: 'assets/images/icons/50km.png',
          reward: 3000,
          current: 0,
          goal: 50,
        ),
        ChallengeData(
          id: '1hour',
          name: '1시간 유지',
          description: '운동 시작 1시간 달성',
          iconPath: 'assets/images/icons/1hour.png',
          reward: 500,
          current: 0,
          goal: 1,
        ),
        ChallengeData(
          id: '10times',
          name: '화이팅!',
          description: '10회 운동 달성',
          iconPath: 'assets/images/icons/10times.png',
          reward: 1000,
          current: 0,
          goal: 10,
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void completeChallenge(String id) {
    final index = _challenges.indexWhere((c) => c.id == id);
    if (index != -1) {
      _challenges[index] = _challenges[index].copyWith(
        completed: true,
      );
      notifyListeners();
    }
  }

  void updateProgress(String id, int progress) {
    final index = _challenges.indexWhere((c) => c.id == id);
    if (index != -1) {
      _challenges[index] = _challenges[index].copyWith(
        current: progress,
      );
      notifyListeners();
    }
  }
} 