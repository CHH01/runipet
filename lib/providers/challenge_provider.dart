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
          id: 'walk_1km',
          name: '1km 걷기',
          description: '1km를 걸어보세요',
          iconPath: 'assets/images/challenges/walk.png',
          reward: 100,
          current: 0,
          goal: 1000,
          completed: false,
        ),
        ChallengeData(
          id: 'walk_5km',
          name: '5km 걷기',
          description: '5km를 걸어보세요',
          iconPath: 'assets/images/challenges/walk.png',
          reward: 500,
          current: 0,
          goal: 5000,
          completed: false,
        ),
        ChallengeData(
          id: 'walk_10km',
          name: '10km 걷기',
          description: '10km를 걸어보세요',
          iconPath: 'assets/images/challenges/walk.png',
          reward: 1000,
          current: 0,
          goal: 10000,
          completed: false,
        ),
        ChallengeData(
          id: 'feed_5',
          name: '5번 밥주기',
          description: '펫에게 5번 밥을 주세요',
          iconPath: 'assets/images/challenges/feed.png',
          reward: 200,
          current: 0,
          goal: 5,
          completed: false,
        ),
        ChallengeData(
          id: 'feed_10',
          name: '10번 밥주기',
          description: '펫에게 10번 밥을 주세요',
          iconPath: 'assets/images/challenges/feed.png',
          reward: 400,
          current: 0,
          goal: 10,
          completed: false,
        ),
        ChallengeData(
          id: 'play_5',
          name: '5번 놀아주기',
          description: '펫과 5번 놀아주세요',
          iconPath: 'assets/images/challenges/play.png',
          reward: 200,
          current: 0,
          goal: 5,
          completed: false,
        ),
        ChallengeData(
          id: 'play_10',
          name: '10번 놀아주기',
          description: '펫과 10번 놀아주세요',
          iconPath: 'assets/images/challenges/play.png',
          reward: 400,
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
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이
      
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