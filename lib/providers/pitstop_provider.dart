import 'package:flutter/foundation.dart';
import '../models/pitstop_data.dart';
import '../services/pitstop_service.dart';

class PitStopProvider with ChangeNotifier {
  final PitStopService _pitStopService;
  PitStopData? _pitStop;
  bool _isLoading = false;
  String? _error;

  PitStopProvider(this._pitStopService);

  PitStopData? get pitStop => _pitStop;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 선문대 서문 피트스탑 ID
  static const int SUNMOON_MAIN_GATE_ID = 1;

  Future<void> loadPitStop() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pitStop = PitStopData(
        id: SUNMOON_MAIN_GATE_ID,
        name: '선문대 서문',
        description: '선문대학교 서문 피트스탑',
        latitude: 36.802935,
        longitude: 127.069930,
        reward_type: 'xp',
        reward_value: 500,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> claimReward() async {
    if (_pitStop == null) {
      throw Exception('피트스탑 정보가 없습니다.');
    }

    try {
      final result = await _pitStopService.claimReward(_pitStop!.id);
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 