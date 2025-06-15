import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/challenge_data.dart';
import '../services/challenge_service.dart';

class ChallengeProvider with ChangeNotifier {
  final ChallengeService _challengeService;
  final _secureStorage = const FlutterSecureStorage();
  List<ChallengeData> _challenges = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitializing = false;

  ChallengeProvider(this._challengeService);

  List<ChallengeData> get challenges => _challenges;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String _getChallengeIconPath(String challengeName) {
    switch (challengeName) {
      case '첫 운동':
        return 'assets/images/icons/first_exercise.png';
      case '50km 달리기':
        return 'assets/images/icons/50km.png';
      case '1시간 유지':
        return 'assets/images/icons/1hour.png';
      case '화이팅!':
        return 'assets/images/icons/10times.png';
      default:
        return 'assets/images/icons/first_exercise.png';
    }
  }

  Future<void> loadChallenges() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final challenges = await _challengeService.getChallenges();
      if (challenges.isEmpty) {
        print('도전과제 목록이 비어있습니다.');
        // 이미 초기화를 시도했는지 확인
        final hasInitialized = await _secureStorage.read(key: 'challenges_initialized');
        if (hasInitialized != 'true' && !_isInitializing) {
          _isInitializing = true;
          await initChallenges();
          await _secureStorage.write(key: 'challenges_initialized', value: 'true');
          _isInitializing = false;
        }
      } else {
        _challenges = challenges.map((challenge) => ChallengeData(
          id: challenge['id'],
          name: challenge['name'],
          description: challenge['description'],
          iconPath: _getChallengeIconPath(challenge['name']),
          current: challenge['progress'] ?? 0,
          goal: challenge['goal'],
          completed: challenge['completed'] ?? false,
          reward_claimed: challenge['reward_claimed'] ?? false,
          reward_type: 'coin',
          reward_value: challenge['reward'] ?? 0,
        )).toList();
      }
    } catch (e) {
      _error = e.toString();
      print('도전과제 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initChallenges() async {
    if (_isInitializing) return;

    try {
      _isInitializing = true;
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _challengeService.initChallenges();
      await loadChallenges();
    } catch (e) {
      _error = e.toString();
      print('도전과제 초기화 실패: $e');
    } finally {
      _isLoading = false;
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> updateProgress(int challengeId, int progress) async {
    try {
      await _challengeService.updateProgress(challengeId, progress);
      await loadChallenges();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> claimReward(int challengeId) async {
    try {
      await _challengeService.claimReward(challengeId);
      await loadChallenges();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
} 