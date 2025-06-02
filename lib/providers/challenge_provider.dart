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
      await Future.delayed(const Duration(seconds: 1));
      _challenges = [
        ChallengeData(
          id: 'first_exercise',
          name: '첫 운동',
          description: '운동 시작하기',
          iconPath: 'assets/images/icons/first_exercise.png',
          reward: 100,
          current: 0,
          goal: 1,
          completed: true,
        ),
        ChallengeData(
          id: '50km',
          name: '50km 달리기',
          description: '누적 거리 50km 달성',
          iconPath: 'assets/images/icons/50km.png',
          reward: 3000,
          current: 0,
          goal: 50,
          completed: false,
        ),
        ChallengeData(
          id: '1hour',
          name: '1시간 유지',
          description: '운동 시작 1시간 달성',
          iconPath: 'assets/images/icons/1hour.png',
          reward: 500,
          current: 0,
          goal: 1,
          completed: true,
        ),
        ChallengeData(
          id: '10times',
          name: '화이팅!',
          description: '10회 운동 달성',
          iconPath: 'assets/images/icons/10times.png',
          reward: 1000,
          current: 0,
          goal: 10,
          completed: false,
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateChallengeProgress(String challengeId, int progress) async {
    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _challenges.indexWhere((c) => c.id == challengeId);
      if (index != -1) {
        final challenge = _challenges[index];
        final newProgress = challenge.current + progress;
        final completed = newProgress >= challenge.goal;
        
        _challenges[index] = challenge.copyWith(
          current: newProgress,
          completed: completed,
        );
        
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  List<ChallengeData> getCompletedChallenges() {
    return _challenges.where((c) => c.completed).toList();
  }

  List<ChallengeData> getInProgressChallenges() {
    return _challenges.where((c) => !c.completed).toList();
  }
} 